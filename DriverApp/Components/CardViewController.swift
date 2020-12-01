//
//  CardViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 19/10/20.
//

import UIKit

protocol CardViewControllerDelegate {
    func didTapButton(_ viewModel: CardViewController, type: TypeDelivery)
    func scan(_ viewC: CardViewController, store: PickupDestination?)
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
        line.layer.cornerRadius = 3
        return line
    }()
    
    
    let orderButton: UIButton={
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    let pendingButton: UIButton={
        let button = UIButton()
        button.setTitle("Pending", for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapPending), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PickUp Store"
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir", size: 16)
        
        
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.textColor = UIColor(named: "darkKasumi")
        label.numberOfLines = 0
        
        return label
    }()
    
    let titleLabelDestination: UILabel = {
        let label = UILabel()
        label.text = "Delivery Location"
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir", size: 16)
        label.numberOfLines = 2
        
        return label
    }()
    
    let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.textColor = UIColor(named: "darkKasumi")
        label.numberOfLines = 2
        
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
        
        img.anchor(left: v.leftAnchor, paddingLeft: 0, width: 21, height: 21)
        img.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        lableText.anchor(top: v.topAnchor, left: img.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
       return v
    }
    
    lazy var orderNoLable = createTitle(icon: UIImage(named: "orderNoCar")!)
    
    lazy var seeDetailButton: UIButton = {
       let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        button.setTitle("See Details", for: .normal)
        button.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(details), for: .touchUpInside)
       return button
    }()
    
    @objc private func details(){
        guard let orderNo = orderData?.order_number,
              let order = orderData?.order_detail,
              let user = orderData?.user_info,
              let orderDetail = orderVm.decryptOrderDetail(data: order, OrderNo: orderNo),
              let userInfo = orderVm.decryptUserInfo(data: user, OrderNo: orderNo) else {
            return
        }
        delegate?.seeDetail(self, order: orderDetail, userInfo: userInfo)
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
        view.backgroundColor = UIColor(named: "whiteKasumi")
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
        destinationLabel.text = "〒\(userInfo.postal_code) \(userInfo.prefecture) \(userInfo.chome) \(userInfo.address) \(userInfo.kana_after_address) \(userInfo.first_name) \(userInfo.last_name) \(userInfo.phone_number)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.roundCorners([.topLeft, .topRight], radius: 21)
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
            delegate?.scan(self, store: orderDetail.pickup_destination[currentIndex])
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
        
        titleLabel.anchor(top: orderNoLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
        storeLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 12)
        titleLabelDestination.anchor(top: storeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        destinationLabel.anchor(top: titleLabelDestination.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        seeDetailButton.anchor(top: destinationLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20, height: 45)
    }
    
    private func setupButton(){
        self.orderButton.anchor(top: self.handleArea.bottomAnchor, left: self.view.leftAnchor, right: self.pendingButton.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 10, height: 45)
        self.pendingButton.anchor(top: self.handleArea.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingRight: 20,width: 100, height: 45)
    }
    
    private func setupDefaultButton(){
        self.orderButton.anchor(top: self.handleArea.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 10, height: 45)
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
        if currentIndex+1 < items.count {
            orderVm.cekStatusItems(data: dataToPost) {[weak self] (res) in
                switch res {
                case .success(let data):
                    DispatchQueue.main.async {
                        let filtered = data.filter({$0.scanned_status == 0})
                        if filtered.count > 0 {
                            self?.titleButton = "Scan Stuff"
                            self?.statusDelivery = .scan
                        }else {
                            self?.titleButton = "Next Store"
                            self?.statusDelivery = .next
                        }
                        self?.orderButton.setTitle(self?.titleButton, for: .normal)
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }else {
            titleButton = "Done Pickup (\(orderNo))"
            statusDelivery = .done_pickup
            orderButton.setTitle(titleButton, for: .normal)
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
                    }else if statusTracking == "on pickup process" {
                        self?.titleButton = "Loading ..."
                        self?.statusDelivery = .nostatus
                        self?.cekScaned()
                        self?.setupDefaultButton()
                    }else if statusTracking == "waiting delivery" {
                        self?.titleButton = "Start Delivery"
                        self?.setupDefaultButton()
                        self?.statusDelivery = .start_delivery
                    }else if statusTracking == "on delivery" {
                        self?.titleButton = "Done Delivery"
                        self?.setupButton()
                        self?.statusDelivery = .done_delivery
                    }else {
                        self?.titleButton = "Start Delivery"
                        self?.setupDefaultButton()
                        self?.statusDelivery = .start_delivery
                    }
                    self?.orderButton.setTitle(self?.titleButton, for: .normal)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
}




