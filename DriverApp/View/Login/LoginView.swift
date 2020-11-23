//
//  LoginView.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import AesEverywhere
import JGProgressHUD
import BLTNBoard

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
            view.showsHorizontalScrollIndicator = false
            view.showsVerticalScrollIndicator = false
            view.bounces = false
            return view
    }()
    
    lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor(named: "orangeKasumi")
        view.layer.cornerRadius = 10
        view.spacing = 16
        view.axis = .vertical
        view.layoutIfNeeded()
        view.layoutMargins = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    
    private let imageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "bgLogin")
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let labelTitleLogin: UILabel = {
       let label = UILabel()
        label.text = "LOGIN"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let forgetPassword: UILabel = {
       let label = UILabel()
        label.text = "Forgot your password"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let lableCode = Reusable.makeLabel(text: "Driver Code", color: .white)
    let lablePass = Reusable.makeLabel(text: "Password", color: .white)
    
    private let codeDriver: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.text = "20110040"
        field.textColor = .white
        field.keyboardType = .numberPad
        return field
    }()

    private let password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.text = "admin"
        field.textColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Submit", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        loginButton.layer.cornerRadius = 45/2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        return loginButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        view.insertSubview(imageView, at: 0)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(containerView)
        
        codeDriver.delegate = self
        password.delegate = self
        loginViewModel.delegate = self
        
        configureNavigationBar()
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
        forgetPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didForgetClick)))
        
    }
    
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .black
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController!.navigationBar.shadowImage = UIImage()
          self.navigationController!.navigationBar.isTranslucent = true
    }
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerView.dropShadow(color: .black, opacity: 0.6, offSet: CGSize(width: 3, height: -3), radius: 10, scale: true)
        codeDriver.addBorder(toSide: .Bottom, withColor: UIColor.white.cgColor, andThickness: 1)
        password.addBorder(toSide: .Bottom, withColor: UIColor.white.cgColor, andThickness: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 200)
        
        containerView.anchor(top: imageView.bottomAnchor, left: scrollView.leftAnchor, right: view.rightAnchor,paddingTop: -40, paddingLeft: 20, paddingRight: 20)
        
        containerView.addArrangedSubview(labelTitleLogin)
        containerView.addArrangedSubview(lableCode)
        codeDriver.anchor(height: 45)
        containerView.addArrangedSubview(codeDriver)
        
        containerView.addArrangedSubview(lablePass)
        password.anchor(height: 45)
        containerView.addArrangedSubview(password)
        containerView.addArrangedSubview(forgetPassword)
        let spacer = UIView()
        spacer.anchor(height: 45)
        containerView.addArrangedSubview(spacer)
        loginButton.anchor(height: 45)
        containerView.addArrangedSubview(loginButton)
        
    
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
        let forgetVc = ForgetViewController()
        navigationController?.pushViewController(forgetVc, animated: true)
        

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


