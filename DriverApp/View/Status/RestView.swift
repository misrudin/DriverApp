//
//  RestView.swift
//  DriverApp
//
//  Created by Indo Office4 on 15/11/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

class RestView: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var inoutVm = InOutViewModel()
    
    private let emptyImage: UIView = {
        let view = UIView()
        let imageView: UIImageView = {
           let img = UIImageView()
            img.image = UIImage(named: "restImage")
            img.clipsToBounds = true
            img.layer.masksToBounds = true
            img.translatesAutoresizingMaskIntoConstraints = false
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.layer.cornerRadius = 120/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    let restLabel = Reusable.makeLabel(text: "Have a good rest.",
                                       font: .systemFont(ofSize: 15, weight: .medium),
                                       color: UIColor(named: "darkKasumi")!, numberOfLines: 0,
                                       alignment: .center)
    
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Back To Work".localiz(), for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 45/2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium )
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
        let action1 = UIAlertAction(title: "Resume".localiz(), style: .default) {[weak self] (_) in
            let data: CheckDriver = CheckDriver(code_driver: codeDriver)
            self?.spiner.show(in: (self?.view)!)
            self?.workNow(data: data)
        }
        
        let action2 = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message: "", customTitle: "Do you want to resume work?".localiz(), customAction1: action1, customAction2: action2)
    }
    
    private func workNow(data: CheckDriver){
        inoutVm.workTimeDriver(data: data) {[weak self] (res) in
            switch res {
            case .failure(let err):
                print(err)
                Helpers().showAlert(view: self!, message: "Something when wrong !".localiz())
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

        view.addSubview(emptyImage)
        view.addSubview(restLabel)
        restLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        view.backgroundColor = .white
        
        emptyImage.centerX(toAnchor: view.centerXAnchor)
        emptyImage.centerY(toAnchor: view.centerYAnchor)
        
        restLabel.top(toAnchor: emptyImage.bottomAnchor, space: 24)
        restLabel.left(toAnchor: view.leftAnchor, space: 10)
        restLabel.right(toAnchor: view.rightAnchor, space: -10)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.top(toAnchor: restLabel.bottomAnchor, space: 30)
        loginButton.left(toAnchor: view.leftAnchor, space: 20)
        loginButton.right(toAnchor: view.rightAnchor, space: -20)
        loginButton.height(45)
    }

}
