//
//  LoginVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import AesEverywhere

class LoginVc: UIViewController {
    
    var loginViewModel = LoginViewModel()
    let pop = PopUpView()
    
    private let labelTitleLogin: UILabel = {
       let label = UILabel()
        label.text = "Welcome to Usmh Driver"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private let lableError: UILabel = {
       let label = UILabel()
        label.text = "Username or Password Wrong"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let codeDriver: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Code Driver"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold )
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    private let forgetPasswordButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Forgot Password", for: .normal)
        loginButton.setTitleColor(.red, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .light )
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    
    private let stakView : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution  = .equalSpacing
        stack.alignment = .center
        stack.spacing   = 16.0
        
        return stack
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(stakView)
        stakView.addArrangedSubview(labelTitleLogin)
        stakView.addArrangedSubview(codeDriver)
        stakView.addArrangedSubview(password)
        stakView.addArrangedSubview(lableError)
        stakView.addArrangedSubview(loginButton)
        stakView.addArrangedSubview(forgetPasswordButton)
        
        
        codeDriver.delegate = self
        password.delegate = self
        loginViewModel.delegate = self
        
        
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
        forgetPasswordButton.addTarget(self, action: #selector(didForgetClick), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stakView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        
        stakView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stakView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        labelTitleLogin.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor,height: 40)
        
        codeDriver.anchor(top: labelTitleLogin.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 40, height: 50)
        password.anchor(top: codeDriver.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 10, height: 50)
        
        loginButton.anchor(top: password.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 20, height: 50)
        
    }
}


//MARK- function

extension LoginVc{
    @objc func didLoginTap(){
        codeDriver.resignFirstResponder()
        password.resignFirstResponder()
        
        guard let codeDriver = codeDriver.text, let password = password.text,
              codeDriver != "" && password != ""
              else {
            return
        }
        view.addSubview(pop)
        self.pop.show = true
        loginViewModel.signIn(codeDriver: codeDriver, password: password)
    }
    
    @objc func didForgetClick(){
        let forgetVc = UINavigationController(rootViewController: ForgetViewController())
        forgetVc.modalPresentationStyle = .fullScreen
        
        present(forgetVc, animated: true, completion: nil)
    }

}


//MARK - UITextField
extension LoginVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeDriver {
            password.becomeFirstResponder()
        }else{
            didLoginTap()
        }
        
        return true
    }
}


extension LoginVc: LoginViewModelDelegate {
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
                self.pop.show = false
        }
    }
    
    func didFailedLogin(_ error: Error) {
        lableError.text = "Code Driver or Password Wrong. Please try again !"
        lableError.isHidden = false
        codeDriver.text = ""
        password.text = ""
        codeDriver.becomeFirstResponder()
        self.pop.show = false
    }
    
  
}
