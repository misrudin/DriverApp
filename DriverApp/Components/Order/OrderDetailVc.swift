//
//  OrderDetailVc.swift
//  DriverApp
//
//  Created by Indo Office4 on 08/02/21.
//

import UIKit
import LanguageManager_iOS

protocol OrderDetailVcDelegate {
    func didTapButton(_ viewModel: OrderDetailVc, type: TypeDelivery)
    func scan(_ viewC: OrderDetailVc, order: Pickup?)
    func startPickup(_ viewC: OrderDetailVc)
    func pending(_ viewC: OrderDetailVc, order: Pickup?)
    func doneAll(_ viewC: OrderDetailVc)
}

enum DisplayPickup {
    case initial
    case start_pickup
    case next
    case done
    case scan
}


class OrderDetailVc: UIViewController {
    
    //MARK: - Variable
    
    var delegate: OrderDetailVcDelegate?
    
    var orderVm = OrderViewModel()
    
    var titleButton: String = ""
    var orderNo: String?
    
    var currentIndex: Int = 0
    var statusDelivery: TypeDelivery!
    
    
    //MARK: - Setter
    
    var display: DisplayPickup! {
        didSet{
            switch display {
            case .initial:
                startPickupButton.isHidden = false
                startScanButton.isHidden = true
                nextButton.isHidden = true
                nextButton.isHidden = true
                donePickupButton.isHidden = true
                container.isHidden = true
                lineView.isHidden = true
                handleArea.isUserInteractionEnabled = false
                estLabel.isHidden = true
                distanceLabel.isHidden = true
                break
            case .start_pickup:
                startPickupButton.isHidden = true
                nextButton.isHidden = true
                startScanButton.isHidden = false
                donePickupButton.isHidden = true
                container.isHidden = false
                lineView.isHidden = false
                handleArea.isUserInteractionEnabled = true
                estLabel.isHidden = false
                distanceLabel.isHidden = false
                break
            case .next:
                startPickupButton.isHidden = true
                startScanButton.isHidden = true
                nextButton.isHidden = false
                donePickupButton.isHidden = true
                container.isHidden = true
                lineView.isHidden = true
                handleArea.isUserInteractionEnabled = false
                estLabel.isHidden = true
                distanceLabel.isHidden = true
                break
            case .done:
                startPickupButton.isHidden = true
                startScanButton.isHidden = true
                nextButton.isHidden = true
                nextButton.isHidden = true
                container.isHidden = true
                lineView.isHidden = true
                donePickupButton.isHidden = false
                handleArea.isUserInteractionEnabled = false
                estLabel.isHidden = true
                distanceLabel.isHidden = true
                break
            case .scan:
                break
            default :
                break
            }
        }
    }
    
    var order: Pickup!{
        didSet {
            lableText.text = "Order No".localiz() + " : " + order.order_number
            storeLabel.text = order.pickup_store_name
            classificationLabel.text = order.classification
            storeAddress.text = order.store_address
            
            let dataN = order.pickup_item?.map({$0.item_name})
            var data = [String]()
                
            _ = dataN.map { e in
                for i in e {
                    data.append(i)
                }
            }
            
            let textArray = data.enumerated().map({(index, element) in
                return "\(index+1). \(element)"
            })
            itemLabel.text = textArray.joined(separator: "\n")
        }
    }
    
    //MARK:- Components
    let handleArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        view.isUserInteractionEnabled = true
        view.isHidden = false
        return view
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
        button.setTitle("Pick Up Order".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startPickupOrder), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    let startScanButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitle("Scan Stuff".localiz(), for: .normal)
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
        button.setTitle("Next Store".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startPickupOrder), for: .touchUpInside)
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
    
    let donePickupButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitle("Done Pickup".localiz(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(donePickup), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
       return button
    }()
    
    
    let container: UIView = {
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PickUp Store".localiz()
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
    
    let storeAddress: UILabel = {
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
        
        view.addSubviews(views: startPickupButton, startScanButton, nextButton,
                         estLabel, distanceLabel,
                         handleArea, lineView, scrollView, donePickupButton)
        scrollView.addSubviews(views: container)
        container.addSubviews(views: orderNoLable, titleLabel, storeLabel, classificationLabel,
                              storeAddress, pendingButton, titleLabelItemName, itemLabel)
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
    
    @objc private func donePickup(){
        delegate?.doneAll(self)
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
        
        startScanButton.top(toAnchor: estLabel.bottomAnchor, space: 10)
        startScanButton.left(toAnchor: view.leftAnchor, space: 10)
        startScanButton.right(toAnchor: view.rightAnchor, space: -10)
        startScanButton.height(40)
        
        nextButton.top(toAnchor: handleArea.bottomAnchor, space: 10)
        nextButton.left(toAnchor: view.leftAnchor, space: 10)
        nextButton.right(toAnchor: view.rightAnchor, space: -10)
        nextButton.height(40)
        
        donePickupButton.top(toAnchor: handleArea.bottomAnchor, space: 10)
        donePickupButton.left(toAnchor: view.leftAnchor, space: 10)
        donePickupButton.right(toAnchor: view.rightAnchor, space: -10)
        donePickupButton.height(40)
        
        //scroll
        scrollView.top(toAnchor: startScanButton.bottomAnchor)
        scrollView.left(toAnchor: view.leftAnchor)
        scrollView.right(toAnchor: view.rightAnchor)
        scrollView.bottom(toAnchor: view.bottomAnchor)
        
        container.left(toAnchor: view.leftAnchor, space: 10)
        container.right(toAnchor: view.rightAnchor, space: -10)
        container.top(toAnchor: scrollView.topAnchor, space: 10)
        container.bottom(toAnchor: scrollView.bottomAnchor, space: -10)
        
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
        
        classificationLabel.top(toAnchor: storeAddress.bottomAnchor, space: 10)
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
