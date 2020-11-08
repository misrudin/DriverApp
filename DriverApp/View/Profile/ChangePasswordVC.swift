//
//  ChangePasswordVC.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 19/10/20.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    var codeDriver: String = ""
    let pop = PopUpView()
    
    private let oldPassword: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Current Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()
    
    private let newPassword: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "New Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()
    
    private let confirmPassword: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Confirm New Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()
    
    private let submitButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Submit New Password", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(oldPassword)
        view.addSubview(newPassword)
        view.addSubview(confirmPassword)
        view.addSubview(submitButton)
        
        configureLayout()
        configureNavigationBar()
        
        submitButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Change Password"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didBack))
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSubmit(){
        guard let oldP = oldPassword.text,
        let newP = newPassword.text,
        let confirmP = confirmPassword.text, oldP != "" && newP != "" && confirmP != "" else {return}
        
        if newP == confirmP {
            view.addSubview(pop)
            pop.show = true
            let data = PasswordModel(code_driver: codeDriver, old_password: oldP, password: newP)
            
            ProfileViewModel().changePassword(data: data) {[weak self] (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {

                        if data.status != 200 {
                            Helpers().showAlert(view: self!, message: data.message)
                            self?.pop.show = false
                        }else{
                            self?.dismiss(animated: true, completion: nil)
                            self?.pop.show = false
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    self?.pop.show = false
                }
                
            }
        }else {
            Helpers().showAlert(view: self, message: "New password not match !")
        }
        
    }
    
    
    
    func configureLayout(){
        oldPassword.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 50)
        newPassword.anchor(top: oldPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        confirmPassword.anchor(top: newPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        submitButton.anchor(top: confirmPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 50)
    }
}
