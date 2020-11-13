//
//  LoginView.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import AesEverywhere
import JGProgressHUD

class LoginView: UIViewController {
    
    var loginViewModel = LoginViewModel()
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
    
    private let forgetPassword: UILabel = {
       let label = UILabel()
        label.text = "Forgot password ?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.mainBlue
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let codeDriver: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Code Driver"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        field.text = "20080019"
        return field
    }()

    private let password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        field.isSecureTextEntry = true
        field.text = "admin"
        return field
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Sign In", for: .normal)
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
        containerView.addSubview(password)
        containerView.addSubview(forgetPassword)
        containerView.addSubview(loginButton)
        
        codeDriver.delegate = self
        password.delegate = self
        loginViewModel.delegate = self
        
        
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
        forgetPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didForgetClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: containerView.leftAnchor, paddingTop: 30, paddingLeft: 16, width: 100, height: 100)
        labelTitleLogin.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        codeDriver.anchor(top: labelTitleLogin.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16, height: 45)
        password.anchor(top: codeDriver.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingLeft: 16, paddingRight: 16, height: 45)
        forgetPassword.anchor(top: password.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        loginButton.anchor(top: forgetPassword.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 45)
    }
}


//MARK- function

extension LoginView{
    @objc func didLoginTap(){
        codeDriver.resignFirstResponder()
        password.resignFirstResponder()
        
        guard let codeDriver = codeDriver.text, let password = password.text,
              codeDriver != "" && password != ""
              else {
            let action = UIAlertAction(title: "Oke", style: .default) { [weak self] _ in
                self?.codeDriver.becomeFirstResponder()
            }
            Helpers().showAlert(view: self, message: "Please input code driver and password !", customTitle: "Hmm", customAction1: action)
            return
        }
        spiner.show(in: view)
        loginViewModel.signIn(codeDriver: codeDriver, password: password)
    }
    
    @objc func didForgetClick(){
        let forgetVc = UINavigationController(rootViewController: ForgetViewController())
        forgetVc.modalPresentationStyle = .fullScreen
        
        present(forgetVc, animated: true, completion: nil)
    }

}


//MARK - UITextField
extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeDriver {
            password.becomeFirstResponder()
        }else{
            didLoginTap()
        }
        
        return true
    }
}


extension LoginView: LoginViewModelDelegate {
    func didLoginSuccess(_ viewModel: LoginViewModel, user: User) {
        codeDriver.text = ""
        password.text = ""
        DispatchQueue.main.async {
            
            let userData: [String:Any] = [
                "codeDriver": user.codeDriver,
                "idDriver":user.id
            ]
          
                UserDefaults.standard.setValue(userData, forKey: "userData")
                self.dismiss(animated: false, completion: nil)
                self.spiner.dismiss()
        }
    }
    
    func didFailedLogin(_ error: Error) {
        let action = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            self?.codeDriver.becomeFirstResponder()
        }
        Helpers().showAlert(view: self, message: "Code driver or password wrong !", customAction1: action)
        codeDriver.text = ""
        password.text = ""
        self.spiner.dismiss()
    }
    
  
}
