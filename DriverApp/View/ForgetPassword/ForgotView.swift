//
//  ForgotView.swift
//  DriverApp
//
//  Created by Indo Office4 on 23/11/20.
//

import UIKit

protocol ForgotViewDelegate {
    func didSendEmail(_ viewContorler: ForgotView, message: String?)
}

class ForgotView: UIViewController {
    
    var delegate: ForgotViewDelegate?
    
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
        return button
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PickUp Store"
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir", size: 16)
        
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(handleArea)
        handleArea.addSubview(lineView)
        
        view.backgroundColor = .white
        configureLayout()
       
        
    }
    
    
    func configureLayout(){
        handleArea.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 40)
        lineView.anchor(width: 70, height: 6)
        lineView.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
        lineView.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        
    }
    
}
