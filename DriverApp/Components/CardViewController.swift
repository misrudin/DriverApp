//
//  CardViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 19/10/20.
//

import UIKit
import LanguageManager_iOS

protocol CardViewControllerDelegate {
    func didTapButton(_ viewModel: CardViewController, type: TypeDelivery)
    func scan(_ viewC: CardViewController, store: PickupDestination?, extra: AnotherPickup?)
    func next(_ viewC: CardViewController, store: PickupDestination?)
    func seeDetail(_ viewC: CardViewController, order: NewOrderDetail?, userInfo: NewUserInfo?)
}

enum TypeDelivery {
    case start_pickup
    case done_pickup
    case start_delivery
    case pending
    case done_delivery
    case next
    case scan
    case nostatus
    case none
}

class CardViewController: UIViewController {
    
    var delegate: CardViewControllerDelegate?
    
    var orderVm = OrderViewModel()
    
    var orderData:NewOrderData? = nil
    var titleButton: String = ""
    var orderNo: String?
    
    var currentIndex: Int = 0
    var statusDelivery: TypeDelivery!
    
    var detailContstaint1: NSLayoutConstraint!
    var detailContstaint2: NSLayoutConstraint!
    var count: Int = 0
    
    var status: Bool = false {
        didSet {
            if status {
                if let orderNo = orderNo {
                    getDetailOrder(orderNo: orderNo)
                }
            }else {
                if let orderNo = orderNo {
                    getDetailOrder(orderNo: orderNo)
                }
            }
        }
    }
    
    let handleArea: UIView = {
        let viewArea = UIView()
        viewArea.backgroundColor = .white
        return viewArea
    }()
    
    let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.layer.cornerRadius = 5
        return line
    }()
    
    
    let orderButton: UIButton={
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    let orderButton2: UIButton={
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    let pendingButton: UIButton={
        let button = UIButton()
        button.setTitle("Pending".localiz(), for: .normal)
        button.backgroundColor = UIColor(named: "darkKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapPending), for: .touchUpInside)
        return button
    }()
    
    let titleLabelItemName: UILabel = {
        let label = UILabel()
        label.text = "Item Name".localiz()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "darkKasumi")
        label.numberOfLines = 3
        
        return label
    }()
    
    let detailItem: UILabel = {
        let label = UILabel()
        label.text = "See Details".localiz()
        label.textColor = UIColor(named: "orangeKasumi")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PickUp Store".localiz()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "darkKasumi")
        
        return label
    }()
    
    let titleLabelDestination: UILabel = {
        let label = UILabel()
        label.text = "Receiver".localiz()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "darkKasumi")
        
        return label
    }()
    
    private let lableText: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = UIColor(named: "darkKasumi")
        return l
    }()
    
    
    private func createTitle(icon: UIImage)-> UIView {
       let  v = UIView()
        
        let img: UIImageView = {
           let i = UIImageView()
            i.image = icon
            i.clipsToBounds = true
            i.layer.masksToBounds = true
            i.layer.cornerRadius = 10
            return i
        }()
        
        v.addSubview(lableText)
        v.addSubview(img)
        
        img.anchor(left: v.leftAnchor, paddingLeft: 0, width: 30, height: 30)
        img.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        lableText.anchor(top: v.topAnchor, left: img.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
       return v
    }
    
    lazy var orderNoLable = createTitle(icon: UIImage(named: "orderNoCar")!)
    
    lazy var seeDetailButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "darkKasumi")
        button.setTitle("Pending".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(details), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
       return button
    }()
    
    @objc private func details(){
        delegate?.didTapButton(self, type: .pending)
    }
    @objc private func didSeeDetail(){
        if itemLabel.numberOfLines == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.itemLabel.numberOfLines = 3
                self.detailItem.text = "See Details".localiz()
            })
        }else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.itemLabel.numberOfLines = 0
                self.detailItem.text = "Hide".localiz()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(handleArea)
        handleArea.addSubview(lineView)
        view.addSubview(orderButton)
        view.addSubview(pendingButton)
        view.addSubview(titleLabel)
        view.addSubview(storeLabel)
        view.addSubview(titleLabelDestination)
        view.addSubview(destinationLabel)
        view.addSubview(seeDetailButton)
        view.addSubview(orderNoLable)
        view.addSubview(orderButton2)
        view.addSubview(titleLabelItemName)
        view.addSubview(itemLabel)
        view.addSubview(detailItem)
        detailItem.isUserInteractionEnabled = true
        detailItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSeeDetail)))
        view.backgroundColor = .white
        configureLayout()
        
        guard let orderNo = orderData?.order_number,
              let order = orderData?.order_detail,
              let user = orderData?.user_info,
              let orderDetail = orderVm.decryptOrderDetail(data: order, OrderNo: orderNo),
              let userInfo = orderVm.decryptUserInfo(data: user, OrderNo: orderNo) else {
            print("oooooo")
            return
        }
        
        lableText.text = orderNo
        
        storeLabel.text = orderDetail.pickup_destination[orderDetail.pickup_destination.count-1].pickup_store_name
        destinationLabel.text = "\(userInfo.first_name) \(userInfo.last_name) 〒\(userInfo.postal_code) \(userInfo.prefecture) \(userInfo.chome) \(userInfo.address) \(userInfo.kana_after_address) \(userInfo.phone_number)"
        destinationLabel.numberOfLines = 0
        
        let dataN = orderDetail.pickup_destination.compactMap({$0.pickup_item.map({$0.item_name})})
        var data = [String]()
            
        _ = dataN.map { e in
            for i in e {
                data.append(i)
            }
        }
        
        let textArray = data.enumerated().map({(index, element) in
            return "\(index+1). \(element)"
        })
        count = textArray.count
        if(textArray.count < 4){
            detailItem.isHidden = true
            titleLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 16).isActive = true
        }else{
            detailItem.isHidden = false
            titleLabel.topAnchor.constraint(equalTo: detailItem.bottomAnchor, constant: 16).isActive = true
        }
        itemLabel.text = textArray.joined(separator: "\n")
        
        detailContstaint1 = titleLabel.topAnchor.constraint(equalTo: detailItem.bottomAnchor, constant: 20)
        detailContstaint2 = titleLabel.topAnchor.constraint(equalTo: orderNoLable.bottomAnchor, constant: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.roundCorners([.topLeft, .topRight], radius: 21)
        
        self.detailContstaint1.isActive = false
        self.detailContstaint2.isActive = true
    }
    
    @objc
    func didTap(){
        guard let orderNo = orderData?.order_number,
              let order = orderData?.order_detail,
              let orderDetail = orderVm.decryptOrderDetail(data: order, OrderNo: orderNo) else {
            return
        }
        
        switch statusDelivery {
        case .start_pickup:
            delegate?.didTapButton(self, type: .start_pickup)
        case .done_pickup:
            delegate?.didTapButton(self, type: .done_pickup)
        case .start_delivery:
            delegate?.didTapButton(self, type: .start_delivery)
        case .done_delivery:
            delegate?.didTapButton(self, type: .done_delivery)
        case .next:
            currentIndex += 1
            if currentIndex < orderDetail.pickup_destination.count {
                delegate?.next(self, store: orderDetail.pickup_destination[currentIndex])
            }
        case .pending:
            delegate?.didTapButton(self, type: .start_delivery)
        case .scan:
            let currentItem = orderDetail.pickup_destination[currentIndex]
            if let extraPickup = orderData?.another_pickup {
                let currentExtra = extraPickup.filter({ $0.pickup_store_name == currentItem.pickup_store_name })
                if currentExtra.count != 0 {
                    delegate?.scan(self, store: currentItem, extra: currentExtra[0])
                }else {
                    delegate?.scan(self, store: currentItem, extra: nil)
                }
            }else {
                delegate?.scan(self, store: currentItem, extra: nil)
            }
            
        default:
            print("undefined !")
        }
    }
    
    @objc
    func didTapPending(){
        delegate?.didTapButton(self, type: .pending)
    }
    
    
    private func configureLayout(){
        handleArea.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 40)
        setupDefaultButton()
        lineView.anchor(width: 70, height: 6)
        lineView.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
        lineView.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        
        
        orderNoLable.anchor(top: orderButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20, height: 30)
        
        titleLabelItemName.anchor(top: orderNoLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        itemLabel.anchor(top: titleLabelItemName.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        detailItem.anchor(top: itemLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        titleLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
        storeLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 12)
        
        pendingButton.anchor(top: handleArea.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 10, height: 45)
        pendingButton.isHidden = true
        orderButton.anchor(top: handleArea.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 10, height: 45)
        orderButton2.anchor(top: pendingButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 10)
        orderButton2.heightAnchor.constraint(equalToConstant: 45).isActive = true
        orderButton2.isHidden = true
        
        seeDetailButton.anchor(top: destinationLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20, height: 45)
        
    }
    
    private func setupButton(){
        pendingButton.isHidden = false
        orderButton2.isHidden = false
        pendingButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        orderButton2.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        
        
        seeDetailButton.isHidden = true
        
        orderButton.isHidden = true
        storeLabel.isHidden = true
        titleLabel.isHidden = true
        orderNoLable.isHidden = true
        
        titleLabelDestination.anchor(top: storeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: -40, paddingLeft: 20, paddingRight: 20)
        destinationLabel.anchor(top: titleLabelDestination.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        destinationLabel.numberOfLines = 0
        titleLabelItemName.anchor(top: orderNoLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
    }
    
    private func setupDefaultButton(){
        pendingButton.isHidden = true
        orderButton2.isHidden = true
        
        seeDetailButton.isHidden = false
        
        orderButton.isHidden = false
        
        storeLabel.isHidden = false
        titleLabel.isHidden = false
        orderNoLable.isHidden = false
        
        titleLabelDestination.anchor(top: storeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        destinationLabel.anchor(top: titleLabelDestination.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }
    
    private func cekScanedItems(items: [PickupDestination]) -> [PickupDestination] {
        var newData: [PickupDestination] = []

        for item in items {
            if item.pickup_item.filter({$0.scan == nil}).count != 0 {
                newData.append(item)
            }
        }

        return newData
    }
    
    private func cekScaned() {
        guard let orderNo = orderData?.order_number,
              let order = orderData?.order_detail,
              let user = orderData?.user_info,
              let orderDetail = orderVm.decryptOrderDetail(data: order, OrderNo: orderNo),
              let userInfo = orderVm.decryptUserInfo(data: user, OrderNo: orderNo) else {
            return
        }
        
        storeLabel.text = orderDetail.pickup_destination[currentIndex].pickup_store_name
        destinationLabel.text = "〒\(userInfo.postal_code) \(userInfo.prefecture) \(userInfo.chome) \(userInfo.address) \(userInfo.kana_after_address) \(userInfo.first_name) \(userInfo.last_name) \(userInfo.phone_number)"
    
        
        let items = orderDetail.pickup_destination
        let data = items[currentIndex]
        
        let dataToCheck = data.pickup_item.map({ $0.qr_code_raw })
        let dataToPost: Scan = Scan(order_number: orderNo, qr_code_raw: dataToCheck)
        //cek apakah current index == items.count
//        print(currentIndex, items.count)/
        if currentIndex < items.count {
            orderVm.cekStatusItems(data: dataToPost) {[weak self] (res) in
                switch res {
                case .success(let data):
                    DispatchQueue.main.async {
                        let filtered = data.filter({$0.scanned_status == 0})
                        if filtered.count > 0 {
                            self?.titleButton = "Scan Stuff".localiz()
                            self?.statusDelivery = .scan
                        }else if filtered.count == 0 && self!.currentIndex == items.count-1 {
                            self?.titleButton = "Done Pickup".localiz()
                            self?.statusDelivery = .done_pickup
                            self?.orderButton.setTitle(self?.titleButton, for: .normal)
                            self?.orderButton2.setTitle(self?.titleButton, for: .normal)
                        }else {
                            self?.titleButton = "Next Store".localiz()
                            self?.statusDelivery = .next
                        }
                        
                        self?.orderButton.setTitle(self?.titleButton, for: .normal)
                        self?.orderButton2.setTitle(self?.titleButton, for: .normal)
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    
    private func hideDetail(){
        DispatchQueue.main.async {
            self.detailItem.isHidden = true
            self.itemLabel.isHidden = true
            self.titleLabelItemName.isHidden = true
            self.detailContstaint1.isActive = false
            self.detailContstaint2.isActive = true
        }
    }
    
    private func showDetail(){
        DispatchQueue.main.async {
            if(self.count < 4){
                self.detailItem.isHidden = true
            }else {
                self.detailItem.isHidden = false
            }
            self.itemLabel.isHidden = false
            self.titleLabelItemName.isHidden = false
            self.detailContstaint1.isActive = true
            self.detailContstaint2.isActive = false
        }
    }
    
    private func getDetailOrder(orderNo: String){
        OrderViewModel().getDetailOrder(orderNo: orderNo) {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let statusTracking = data.status_tracking
                    
                    if statusTracking == "wait for pickup" || statusTracking == "" {
                        self?.titleButton = "Pickup Order"
                        self?.setupDefaultButton()
                        self?.statusDelivery = .start_pickup
                        self?.hideDetail()
                    }else if statusTracking == "on pickup process" {
                        self?.titleButton = "Loading".localiz()
                        self?.statusDelivery = .nostatus
                        self?.cekScaned()
                        self?.setupDefaultButton()
                        self?.hideDetail()
                    }else if statusTracking == "waiting delivery" {
                        self?.titleButton = "Start Delivery".localiz()
                        self?.setupDefaultButton()
                        self?.statusDelivery = .start_delivery
                        self?.showDetail()
                    }else if statusTracking == "on delivery" {
                        self?.titleButton = "Done Delivery".localiz()
                        self?.setupButton()
                        self?.statusDelivery = .done_delivery
                        self?.showDetail()
                    }else {
                        self?.titleButton = "Pickup Order".localiz()
                        self?.setupDefaultButton()
                        self?.statusDelivery = .start_pickup
                        self?.hideDetail()
                        self?.seeDetailButton.isHidden = true
                    }
                    self?.orderButton.setTitle(self?.titleButton, for: .normal)
                    self?.orderButton2.setTitle(self?.titleButton, for: .normal)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
}




