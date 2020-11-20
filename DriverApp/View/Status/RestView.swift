//
//  RestView.swift
//  DriverApp
//
//  Created by Indo Office4 on 15/11/20.
//

import UIKit
import JGProgressHUD

class RestView: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    var inoutVm = InOutViewModel()
    
    private let labelRest: UILabel = {
       let l = UILabel()
        l.text = "Rest"
        l.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        l.textAlignment = .center
        l.textColor = UIColor(named: "orangeKasumi")
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Go Work Again", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold )
        loginButton.addTarget(self, action: #selector(work), for: .touchUpInside)
        return loginButton
    }()
    
    @objc
    func work(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        let action1 = UIAlertAction(title: "Yes", style: .default) {[weak self] (_) in
            let data: CheckDriver = CheckDriver(code_driver: codeDriver)
            self?.spiner.show(in: (self?.view)!)
            self?.workNow(data: data)
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message: "Start work now ?", customTitle: "Ready", customAction1: action1, customAction2: action2)
    }
    
    private func workNow(data: CheckDriver){
        inoutVm.workTimeDriver(data: data) {[weak self] (res) in
            switch res {
            case .failure(let err):
                print(err)
                Helpers().showAlert(view: self!, message: "Something when wrong !")
                self?.spiner.dismiss()
            case .success(let oke):
                DispatchQueue.main.async {
                    if oke == true {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    self?.spiner.dismiss()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(labelRest)
        view.addSubview(loginButton)
        view.backgroundColor = .white
        
        labelRest.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        labelRest.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
    }

}
