//
//  ForgetViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import UIKit

class ForgetViewController: UIViewController {
    
    private let labelTitle: UILabel = {
       let label = UILabel()
        label.text = "USMH DRIVER"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelDescription: UILabel = {
       let label = UILabel()
        label.text = "Masukan email untuk melakukan reset password"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailInput: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .emailAddress
        return field
    }()
    
    private let actionButton: UIButton={
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(labelTitle)
        view.addSubview(labelDescription)
        view.addSubview(emailInput)
        view.addSubview(actionButton)
        
    }
    
    
    
    
    
    func configureLayout(){
        NSLayoutConstraint.activate([
        
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.width/2),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            labelDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            emailInput.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 30),
            emailInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            emailInput.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            emailInput.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "Forget Password"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didBack))
    }
    
    @objc func didBack(){
        dismiss(animated: true, completion: nil)
    }

}
