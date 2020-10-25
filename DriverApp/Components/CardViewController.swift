//
//  CardViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 19/10/20.
//

import UIKit

protocol CardViewControllerDelegate {
    func didTapButton(_ viewModel: CardViewController, type: TypeDelivery)
}

enum TypeDelivery {
    case start_pickup
    case done_pickup
    case start_delivery
    case pending
    case done_delivery
    case none
}

class CardViewController: UIViewController {
    
    var delegate: CardViewControllerDelegate?
    
    var orderData:Order? = nil
    var titleButton: String = ""
    var orderNo: String?
    
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
        button.layer.cornerRadius = 5
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
        button.layer.cornerRadius = 5
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
        
        return label
    }()
    
    let titleLabelDestination: UILabel = {
        let label = UILabel()
        label.text = "Delivery Location"
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir", size: 16)
        
        return label
    }()
    
    let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        
        return label
    }()
    
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
        
        
        view.backgroundColor = .white
        configureLayout()
        guard
            let origin = orderData?.storeDetail.storeName,
            let destination = orderData?.addressUser else {
            return
        }
        
        self.storeLabel.text = origin
        self.destinationLabel.text = destination
        
    }
    
    @objc
    func didTap(){
        guard let statusTracking = orderData?.statusTracking else {
            return
        }
        if statusTracking == "wait for pickup" {
            delegate?.didTapButton(self, type: .start_pickup)
        }else if statusTracking == "on pickup process" {
            delegate?.didTapButton(self, type: .done_pickup)
        }else if statusTracking == "waiting delivery" || statusTracking == "" {
            delegate?.didTapButton(self, type: .start_delivery)
        }else if statusTracking == "on delivery" {
            delegate?.didTapButton(self, type: .done_delivery)
        }else {
            delegate?.didTapButton(self, type: .start_delivery)
        }
    }
    
    @objc
    func didTapPending(){
        delegate?.didTapButton(self, type: .pending)
    }
    
    
    func configureLayout(){
        handleArea.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 40)
        setupDefaultButton()
        lineView.anchor(width: 70, height: 6)
        lineView.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
        lineView.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        
        
        titleLabel.anchor(top: orderButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        storeLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 12)
        titleLabelDestination.anchor(top: storeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        destinationLabel.anchor(top: titleLabelDestination.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }
    
    func setupButton(){
        self.orderButton.anchor(top: self.handleArea.bottomAnchor, left: self.view.leftAnchor, right: self.pendingButton.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 10, height: 40)
        self.pendingButton.anchor(top: self.handleArea.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingRight: 20,width: 100, height: 40)
    }
    
    func setupDefaultButton(){
        self.orderButton.anchor(top: self.handleArea.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 10, height: 40)
    }
    
    func getDetailOrder(orderNo: String){
        OrderViewModel().getDetailOrder(orderNo: orderNo) {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let statusTracking = data.statusTracking
                    
                    self?.orderData = data
                    if statusTracking == "wait for pickup" || statusTracking == "" {
                        self?.titleButton = "Pickup Order (\(orderNo))"
                        self?.setupDefaultButton()
                    }else if statusTracking == "on pickup process" {
                        self?.titleButton = "Done Pickup (\(orderNo))"
                        self?.setupDefaultButton()
                    }else if statusTracking == "waiting delivery" {
                        self?.titleButton = "Start Delivery (\(orderNo))"
                        self?.setupDefaultButton()
                    }else if statusTracking == "on delivery" {
                        self?.titleButton = "Done Delivery (\(orderNo))"
                        self?.setupButton()
                    }else {
                        self?.titleButton = "Start Delivery (\(orderNo))"
                        self?.setupDefaultButton()
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




