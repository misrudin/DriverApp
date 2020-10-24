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
        label.text = "USMH DRIVER"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        return stack
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(labelTitleLogin)
        view.addSubview(codeDriver)
        view.addSubview(password)
        view.addSubview(lableError)
        view.addSubview(loginButton)
        view.addSubview(forgetPasswordButton)
        
        
        codeDriver.delegate = self
        password.delegate = self
        loginViewModel.delegate = self
        
        
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
        forgetPasswordButton.addTarget(self, action: #selector(didForgetClick), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
        
            labelTitleLogin.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.width/2),
            labelTitleLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelTitleLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelTitleLogin.heightAnchor.constraint(equalToConstant: 30),
            
            codeDriver.topAnchor.constraint(equalTo: labelTitleLogin.bottomAnchor,constant: 40),
            codeDriver.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            codeDriver.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            codeDriver.heightAnchor.constraint(equalToConstant: 50),
            
            password.topAnchor.constraint(equalTo: codeDriver.bottomAnchor,constant: 20),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            password.heightAnchor.constraint(equalToConstant: 50),
            
            lableError.topAnchor.constraint(equalTo: password.bottomAnchor,constant: 20),
            lableError.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            lableError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            loginButton.topAnchor.constraint(equalTo: lableError.bottomAnchor,constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 20),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            forgetPasswordButton.heightAnchor.constraint(equalToConstant: 50),
        
        ])
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
