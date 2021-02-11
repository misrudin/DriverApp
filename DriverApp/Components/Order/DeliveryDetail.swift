//
//  DeliveryDetail.swift
//  DriverApp
//
//  Created by Indo Office4 on 09/02/21.
//

import UIKit
import LanguageManager_iOS

protocol DeliveryDetailDelegate {
    func didTapButton(_ viewModel: DeliveryDetail, type: TypeDelivery)
    func scan(_ viewC: DeliveryDetail, order: NewDelivery?)
    func startPickup(_ viewC: DeliveryDetail)
    func pending(_ viewC: DeliveryDetail, order: NewDelivery?)
    func doneBackToStore(_ viewC: DeliveryDetail)
}

enum DisplayDelivery {
    case initial
    case start_pickup
    case next
    case done
    case bopis
    case scan
}


class DeliveryDetail: UIViewController {
    
    //MARK: - Variable
    
    var delegate: DeliveryDetailDelegate?
    
    var orderVm = OrderViewModel()
    
    var titleButton: String = ""
    var orderNo: String?
    
    var currentIndex: Int = 0
    var statusDelivery: TypeDelivery!
    
    var detailContstaint1: NSLayoutConstraint!
    var detailContstaint2: NSLayoutConstraint!
    
    //MARK: - Setter
    
    var display: DisplayDelivery! {
        didSet{
            switch display {
            case .initial:
                startPickupButton.isHidden = false
                doneButton.isHidden = true
                nextButton.isHidden = true
                nextButton.isHidden = true
                container.isHidden = true
                lineView.isHidden = true
                handleArea.isUserInteractionEnabled = false
                estLabel.isHidden = true
                distanceLabel.isHidden = true
                backToStoreButton.isHidden = true
                container2.isHidden = true
                container3.isHidden = true
                break
            case .start_pickup:
                startPickupButton.isHidden = true
                nextButton.isHidden = true
                doneButton.isHidden = false
                container.isHidden = false
                lineView.isHidden = false
                handleArea.isUserInteractionEnabled = true
                estLabel.isHidden = false
                distanceLabel.isHidden = false
                backToStoreButton.isHidden = true
                container2.isHidden = true
                container3.isHidden = true
                break
            case .next:
                startPickupButton.isHidden = true
                doneButton.isHidden = true
                nextButton.isHidden = false
                container.isHidden = true
                lineView.isHidden = true
                handleArea.isUserInteractionEnabled = false
                backToStoreButton.isHidden = true
                container2.isHidden = true
                container3.isHidden = true
                break
            case .done:
                startPickupButton.isHidden = true
                doneButton.isHidden = true
                nextButton.isHidden = true
                container.isHidden = true
                backToStoreButton.isHidden = false
                lineView.isHidden = false
                handleArea.isUserInteractionEnabled = true
                container2.isHidden = false
                container3.isHidden = true
                break
            case .bopis:
                startPickupButton.isHidden = true
                doneButton.isHidden = true
                nextButton.isHidden = true
                container.isHidden = true
                backToStoreButton.isHidden = false
                lineView.isHidden = false
                handleArea.isUserInteractionEnabled = true
                container2.isHidden = true
                container3.isHidden = false
                break
            case .scan:
                break
            default :
                break
            }
        }
    }
    
    var store: Pickup! {
        didSet {
            backStoreName.text = store.pickup_store_name
            backStoreAddress.text = store.store_address
            
            lableText2.text = "Order No".localiz() + " : " + store.order_number
            storeLabel2.text = store.pickup_store_name
            storeAddress2.text = store.store_address
        }
    }
    
    var order: NewDelivery!{
        didSet {
            lableText.text = "Order No".localiz() + " : " + order.order_number
            
            let dataN = order.pickup_item?.compactMap({$0.pickup_item?.map({$0.item_name})})
            let dataItems = dataN?.flatMap({$0})
            
            var data = [String]()

            _ = dataItems.map { e in
                for i in e {
                    data.append(i)
                }
            }

            let textArray = data.enumerated().map({(index, element) in
                return "\(index+1). \(element)"
            })
            itemLabel.text = textArray.joined(separator: "\n")
            
            guard let userInfo = orderVm.decryptUserInfo(data: order.user_info!, OrderNo: order.order_number) else {
                return
            }

            storeLabel.text = "\(userInfo.first_name) \(userInfo.last_name)"
            storeAddress.text = userInfo.address
            phoneNumber.text = userInfo.phone_number
        }
    }
    
    //MARK:- Components
    let handleArea: UIView = {
        let viewArea = UIView()
        viewArea.backgroundColor = UIColor(named: "whiteKasumi")
        return viewArea
    }()
    
    let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(named: "borderColor2")
        line.layer.cornerRadius = 1
        line.alpha = 0.5
        return line
    }()
    
    let startPickupButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitle("Start Delivery".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startPickupOrder), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    let doneButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitle("Done Delivery".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scanOrder), for: .touchUpInside)
        button.isHidden = true
       return button
    }()
    
    let nextButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitle("Next Delivery".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startPickupOrder), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
       return button
    }()
    
    let backToStoreButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitle("Done".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(doneInStore), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
       return button
    }()
    
    let pendingButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "darkKasumi")
        button.setTitle("Pending".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pendingOrder), for: .touchUpInside)
       return button
    }()
    
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let container2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let container3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let lableText: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = UIColor(named: "labelColor")
        return l
    }()
    
    private let lableText2: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = UIColor(named: "labelColor")
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
    
    private func createTitle2(icon: UIImage)-> UIView {
       let  v = UIView()
        
        let img: UIImageView = {
           let i = UIImageView()
            i.image = icon
            i.clipsToBounds = true
            i.layer.masksToBounds = true
            i.layer.cornerRadius = 10
            return i
        }()
        
        v.addSubview(lableText2)
        v.addSubview(img)
        
        img.anchor(left: v.leftAnchor, paddingLeft: 0, width: 30, height: 30)
        img.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        lableText2.anchor(top: v.topAnchor, left: img.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
       return v
    }
    
    lazy var orderNoLable = createTitle(icon: UIImage(named: "orderNoCar")!)
    lazy var orderNoLable2 = createTitle2(icon: UIImage(named: "orderNoCar")!)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Receiver".localiz()
        label.textColor = UIColor(named: "labelSecondary")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "BOPIS Store".localiz()
        label.textColor = UIColor(named: "labelSecondary")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let classificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "labelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "labelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let storeLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "labelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let storeAddress: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "labelSecondary")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let storeAddress2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "labelSecondary")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let phoneNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "labelSecondary")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let titleLabelItemName: UILabel = {
        let label = UILabel()
        label.text = "Item Name".localiz()
        label.textColor = UIColor(named: "labelSecondary")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(named: "labelColor")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - scroll
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        scroll.frame = self.view.bounds
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    //back to store components
    let backStoreName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "labelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let backStoreAddress: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "labelSecondary")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: - Estimasi Waktu
    let estLabel = Reusable.makeLabel(text: "",
                                      font: .systemFont(ofSize: 14, weight: .medium),
                                       color: UIColor(named: "orangeKasumi")!)
    let distanceLabel = Reusable.makeLabel(text: "",
                                           font: .systemFont(ofSize: 14, weight: .medium),
                                           color: UIColor(named: "labelColor")!)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        
        view.addSubviews(views: startPickupButton, doneButton, nextButton,
                         estLabel, distanceLabel, backToStoreButton,
                         handleArea, lineView, scrollView)
        scrollView.addSubviews(views: container, container2, container3)
        container.addSubviews(views: orderNoLable, titleLabel, storeLabel, classificationLabel,
                              storeAddress, pendingButton, titleLabelItemName, itemLabel, phoneNumber)
        container2.addSubviews(views: backStoreName, backStoreAddress)
        container3.addSubviews(views: orderNoLable2, storeLabel2, storeAddress2, titleLabel2)
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.roundCorners([.topLeft, .topRight], radius: 21)
    }
    
    //MARK: - Functional
    @objc private func scanOrder(){
        delegate?.scan(self, order: order)
    }
    
    @objc private func pendingOrder(){
        delegate?.pending(self, order: order)
    }
    
    @objc private func doneInStore(){
        delegate?.doneBackToStore(self)
    }
    
    private func configureLayout(){
        
        estLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        estLabel.anchor(top: handleArea.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 10)
        distanceLabel.anchor(top: handleArea.bottomAnchor, left: estLabel.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingRight: 10)
        
        handleArea.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 30)
        lineView.anchor(width: 30, height: 3)
        lineView.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
        lineView.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        
        startPickupButton.top(toAnchor: handleArea.bottomAnchor, space: 10)
        startPickupButton.left(toAnchor: view.leftAnchor, space: 10)
        startPickupButton.right(toAnchor: view.rightAnchor, space: -10)
        startPickupButton.height(40)
        
        doneButton.top(toAnchor: estLabel.bottomAnchor, space: 10)
        doneButton.left(toAnchor: view.leftAnchor, space: 10)
        doneButton.right(toAnchor: view.rightAnchor, space: -10)
        doneButton.height(40)
        
        nextButton.top(toAnchor: handleArea.bottomAnchor, space: 10)
        nextButton.left(toAnchor: view.leftAnchor, space: 10)
        nextButton.right(toAnchor: view.rightAnchor, space: -10)
        nextButton.height(40)
        
        backToStoreButton.top(toAnchor: estLabel.bottomAnchor, space: 10)
        backToStoreButton.left(toAnchor: view.leftAnchor, space: 10)
        backToStoreButton.right(toAnchor: view.rightAnchor, space: -10)
        backToStoreButton.height(40)
        
        //scroll
        scrollView.top(toAnchor: doneButton.bottomAnchor)
        scrollView.left(toAnchor: view.leftAnchor)
        scrollView.right(toAnchor: view.rightAnchor)
        scrollView.bottom(toAnchor: view.bottomAnchor)
        
        container.left(toAnchor: view.leftAnchor, space: 10)
        container.right(toAnchor: view.rightAnchor, space: -10)
        container.top(toAnchor: scrollView.topAnchor, space: 10)
        container.bottom(toAnchor: scrollView.bottomAnchor, space: -10)
        
        container2.left(toAnchor: view.leftAnchor, space: 10)
        container2.right(toAnchor: view.rightAnchor, space: -10)
        container2.top(toAnchor: backToStoreButton.bottomAnchor, space: 10)
        
        container3.left(toAnchor: view.leftAnchor, space: 10)
        container3.right(toAnchor: view.rightAnchor, space: -10)
        container3.top(toAnchor: backToStoreButton.bottomAnchor, space: 10)
        
        //inside container 3 style
        orderNoLable2.translatesAutoresizingMaskIntoConstraints = false
        orderNoLable2.left(toAnchor: container3.leftAnchor)
        orderNoLable2.top(toAnchor: container3.topAnchor)
        orderNoLable2.right(toAnchor: container3.rightAnchor)
        
        titleLabel2.top(toAnchor: orderNoLable2.bottomAnchor, space: 10)
        titleLabel2.left(toAnchor: container3.leftAnchor)
        titleLabel2.right(toAnchor: container3.rightAnchor)
        
        storeLabel2.top(toAnchor: titleLabel2.bottomAnchor, space: 5)
        storeLabel2.left(toAnchor: container3.leftAnchor)
        storeLabel2.right(toAnchor: container3.rightAnchor)
        
        storeAddress2.top(toAnchor: storeLabel2.bottomAnchor, space: 5)
        storeAddress2.left(toAnchor: container3.leftAnchor)
        storeAddress2.right(toAnchor: container3.rightAnchor)
        
        //inside container 2 style
        backStoreName.top(toAnchor: container2.topAnchor)
        backStoreName.left(toAnchor: container2.leftAnchor)
        backStoreName.right(toAnchor: container2.rightAnchor)
        
        backStoreAddress.top(toAnchor: backStoreName.bottomAnchor, space: 5)
        backStoreAddress.left(toAnchor: container2.leftAnchor)
        backStoreAddress.right(toAnchor: container2.rightAnchor)
        backStoreAddress.bottom(toAnchor: container2.bottomAnchor, space: -10)
        
        //inside container style
        orderNoLable.translatesAutoresizingMaskIntoConstraints = false
        orderNoLable.left(toAnchor: container.leftAnchor)
        orderNoLable.top(toAnchor: container.topAnchor)
        orderNoLable.right(toAnchor: container.rightAnchor)
        
        titleLabelItemName.top(toAnchor: orderNoLable.bottomAnchor, space: 10)
        titleLabelItemName.left(toAnchor: container.leftAnchor)
        titleLabelItemName.right(toAnchor: container.rightAnchor)
        
        itemLabel.top(toAnchor: titleLabelItemName.bottomAnchor, space: 5)
        itemLabel.left(toAnchor: container.leftAnchor)
        itemLabel.right(toAnchor: container.rightAnchor)
        
        titleLabel.top(toAnchor: itemLabel.bottomAnchor, space: 10)
        titleLabel.left(toAnchor: container.leftAnchor)
        titleLabel.right(toAnchor: container.rightAnchor)
        
        storeLabel.top(toAnchor: titleLabel.bottomAnchor, space: 5)
        storeLabel.left(toAnchor: container.leftAnchor)
        storeLabel.right(toAnchor: container.rightAnchor)
        
        storeAddress.top(toAnchor: storeLabel.bottomAnchor, space: 5)
        storeAddress.left(toAnchor: container.leftAnchor)
        storeAddress.right(toAnchor: container.rightAnchor)
        
        phoneNumber.top(toAnchor: storeAddress.bottomAnchor, space: 5)
        phoneNumber.left(toAnchor: container.leftAnchor)
        phoneNumber.right(toAnchor: container.rightAnchor)
        
        classificationLabel.top(toAnchor: phoneNumber.bottomAnchor, space: 10)
        classificationLabel.left(toAnchor: container.leftAnchor)
        classificationLabel.right(toAnchor: container.rightAnchor)
        
        pendingButton.top(toAnchor: classificationLabel.bottomAnchor, space: 20)
        pendingButton.right(toAnchor: container.rightAnchor)
        pendingButton.height(30)
        pendingButton.width(100)
        pendingButton.bottom(toAnchor: container.bottomAnchor, space: -10)
    }
    
    @objc private func startPickupOrder(){
        delegate?.startPickup(self)
    }
}
