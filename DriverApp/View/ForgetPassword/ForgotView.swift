//
//  ForgotView.swift
//  DriverApp
//
//  Created by Indo Office4 on 25/11/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

class ForgotView: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var forgotVm = ForgotViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()

    @IBOutlet var line: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitlw: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        titleLable.text = "Forgot your password ?".localiz()
        subTitlw.text = "Enter your email address and we will share a link to create a new password".localiz()
        
        
    }
    
    @objc
    private func tap(){
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        styleElement()
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        tap()
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    private func styleElement(){
        line.layer.cornerRadius = 2
        line.backgroundColor = .white
        
        email.layer.cornerRadius = 5
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor(named: "darkKasumi")?.cgColor
        email.keyboardType = .emailAddress
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        email.placeholder = "Email".localiz()
        
        submit.backgroundColor = UIColor(named: "orangeKasumi")
        submit.setTitleColor(.white, for: .normal)
        submit.layer.cornerRadius = 5
        submit.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        
        email.becomeFirstResponder()
        
    }
    
    @objc
    func didSubmit(){
        email.resignFirstResponder()
        guard let email = email.text,
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
                let action = UIAlertAction(title: "Try again".localiz(), style: .default) {[weak self] (_) in
                    self?.email.becomeFirstResponder()
                }
                Helpers().showAlert(view: self, message: "Email not found !".localiz(),customAction1: action)
                self.spiner.dismiss()
            }
        }
    }
    
    private func showMessageToUser(){
        let action = UIAlertAction(title: "Oke", style: .default) {[weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        Helpers().showAlert(view: self, message: "Please check your email !".localiz(), customTitle: "Success".localiz(), customAction1: action)
    }



}
