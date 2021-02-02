//
//  ChangePasswordVC.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 19/10/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

class ChangePasswordVC: UIViewController {
    
    var codeDriver: String = ""
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    private let oldPassword: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "Current Password".localiz()
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
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "New Password".localiz()
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
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "Confirm New Password".localiz()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()
    
    private let submitButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Save".localiz(), for: .normal)
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
        navigationItem.title = "Change Password".localiz()
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
        view.endEditing(true)
        
        if newP == confirmP {
            let data = PasswordModel(code_driver: codeDriver, old_password: oldP, password: newP)
            
            
            let action = UIAlertAction(title: "Oke".localiz(), style: .default) { (_) in
                self.editStart(data: data)
            }
            let action2 = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
            Helpers().showAlert(view: self, message: "", customTitle: "Do you want to complete the edit?".localiz(), customAction1: action, customAction2: action2)
        }else {
            Helpers().showAlert(view: self, message: "New password not match !".localiz())
        }
        
    }
    
    private func editStart(data: PasswordModel){
        spiner.show(in: view)
        ProfileViewModel().changePassword(data: data) {[weak self] (result) in
            switch result {
            case .success(let oke):
                DispatchQueue.main.async {
                    self?.spiner.dismiss()
                    if oke {
                        let action = UIAlertAction(title: "Oke".localiz(), style: .default) { (_) in
                            self?.navigationController?.popViewController(animated: true)
                        }
                        Helpers().showAlert(view: self!, message: "Editing is complete".localiz(), customTitle: "Success".localiz(), customAction1: action)
                    }
                }
                
            case .failure(let error):
                Helpers().showAlert(view: self!, message: error.localizedDescription, customTitle: "")
                self?.spiner.dismiss()
            }
            
        }
    }
    
    
    
    func configureLayout(){
        oldPassword.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 50)
        newPassword.anchor(top: oldPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        confirmPassword.anchor(top: newPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        submitButton.anchor(top: confirmPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 50)
    }
}
