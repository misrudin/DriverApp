//
//  ForgetViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import UIKit
import AesEverywhere
import JGProgressHUD

class ForgetViewController: UIViewController {
    
    var forgotVm = ForgotViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var scrollView: UIScrollView = {
            let view = UIScrollView(frame: .zero)
            view.backgroundColor = .white
            view.frame = self.view.bounds
            view.contentSize = contentViewSize
            view.autoresizingMask = .flexibleHeight
            view.showsHorizontalScrollIndicator = true
            view.bounces = true
            return view
    }()
    
    lazy var containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.frame.size = contentViewSize
            return view
    }()
    
    
    private let imageView: UIImageView = {
       let img = UIImageView()
        img.layer.cornerRadius = 5
        img.image = UIImage(named: "logoKasumi")
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let labelTitleLogin: UILabel = {
       let label = UILabel()
        label.text = "Kasumi driver management"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.mainBlue
        label.numberOfLines = 0
        return label
    }()
    
    private let codeDriver: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        field.keyboardType = .emailAddress
        field.text = "misrudinz@gmail.com"
        return field
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Submit", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold )
        return loginButton
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(labelTitleLogin)
        containerView.addSubview(codeDriver)
        containerView.addSubview(loginButton)
        
        codeDriver.delegate = self
        
        configureNavigationBar()
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: containerView.leftAnchor, paddingTop: 30, paddingLeft: 16, width: 100, height: 100)
        labelTitleLogin.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        codeDriver.anchor(top: labelTitleLogin.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16, height: 45)
        loginButton.anchor(top: codeDriver.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 45)
    }
}


//MARK- function

extension ForgetViewController{
    
    func configureNavigationBar(){
        navigationItem.title = "Forget Password"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    func showMessageToUser(){
        let action = UIAlertAction(title: "Oke", style: .default) {[weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        Helpers().showAlert(view: self, message: "Please check your email !", customTitle: "Success", customAction1: action)
    }
    
    @objc func didLoginTap(){
        codeDriver.resignFirstResponder()
        
        guard let email = codeDriver.text,
              email != ""
              else {
            return
        }
        
        spiner.show(in: view)
        forgotVm.forgotPassword(email: email) { (res) in
            switch res {
            case .success(_):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    self.showMessageToUser()
                }
            case .failure(_):
                let action = UIAlertAction(title: "Try again", style: .default) {[weak self] (_) in
                    self?.codeDriver.becomeFirstResponder()
                }
                Helpers().showAlert(view: self, message: "Email not found !",customAction1: action)
                self.spiner.dismiss()
            }
        }
        
    }
}


//MARK - UITextField
extension ForgetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeDriver {
            didLoginTap()
        }
        
        return true
    }
}

