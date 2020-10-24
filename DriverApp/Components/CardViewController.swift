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
    
//    let containerView: UIView = {
//        let viewArea = UIView()
//        viewArea.backgroundColor = .red
//        return viewArea
//    }()
    
    let orderButton: UIButton={
        let button = UIButton()
        button.setTitle("Pickup Order", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
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
        view.addSubview(titleLabel)
        view.addSubview(storeLabel)
        view.addSubview(titleLabelDestination)
        view.addSubview(destinationLabel)
        
        
        view.backgroundColor = .white
        configureLayout()
        guard let orderNo = orderData?.orderNumber,
              let origin = orderData?.storeDetail.storeName,
              let destination = orderData?.addressUser,
              let statusTracking = orderData?.statusTracking else {
            return
        }
        

        DispatchQueue.main.async { [self] in
            
            if statusTracking == "wait for pickup" {
                self.titleButton = "Pickup Order (\(orderNo))"
            }else if statusTracking == "on pickup process" {
                self.titleButton = "Done Pickup (\(orderNo))"
            }else if statusTracking == "waiting delivery" || statusTracking == "" {
                self.titleButton = "Start Delivery (\(orderNo))"
            }else if statusTracking == "on delivery" {
                self.titleButton = "Done Delivery (\(orderNo))"
            }else {
                self.titleButton = "Done Delivery (\(orderNo))"
            }
            
            self.orderButton.setTitle(self.titleButton, for: .normal)
            self.storeLabel.text = origin
            self.destinationLabel.text = destination
        }
        
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
            delegate?.didTapButton(self, type: .none)
        }
    }
    
    
    func configureLayout(){
        handleArea.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 40)
        orderButton.anchor(top: handleArea.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, height: 40)
        
        lineView.anchor(width: 70, height: 6)
        lineView.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
        lineView.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        
       
        titleLabel.anchor(top: orderButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        storeLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 12)
        titleLabelDestination.anchor(top: storeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        destinationLabel.anchor(top: titleLabelDestination.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }

}




