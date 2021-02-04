//
//  RestViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

class RestViewController: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var inoutVm = InOutViewModel()
    
    let container: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "whiteKasumi")
        return v
    }()
    
    lazy var switchBtn: UISwitch = {
       let sw = UISwitch()
        sw.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        sw.isOn = false
        return sw
    }()
    
    @objc func switchValueDidChange(sender:UISwitch!)
    {
        if (sender.isOn == true){
            on()
        }
        else{
            off()
        }
    }
    
    private func on(){
        let action1 = UIAlertAction(title: "Start".localiz(), style: .default) {[weak self] (_) in
            self?.start()
        }
        
        let action2 = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { _ in
            self.switchBtn.isOn = false
            self.switchBtn.setOn(false, animated: true)
        }
        Helpers().showAlert(view: self, message: "", customTitle: "Do you want to start a break?".localiz(), customAction1: action1, customAction2: action2)
    }
    
    private func start(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        let data: CheckDriver = CheckDriver(code_driver: codeDriver)
        restNow(data: data)
    }
    
    private func restNow(data: CheckDriver){
        spiner.show(in: view)
        inoutVm.restTimeDriver(data: data) {[weak self] (res) in
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
    
    private func off(){
        print("off")
    }
    
    lazy var imageRest: UIImageView = {
       let iv = UIImageView()
//        iv.image = UIImage(named: "rest")
        iv.backgroundColor = UIColor(named: "orangeKasumi")
        iv.layer.cornerRadius = 8
        iv.image = UIImage(named:
                            "rest")?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5,
                            right: -5))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var lable = Reusable.makeLabel(text: "Activate rest now".localiz())

    override func viewDidLoad() {
        super.viewDidLoad()

        lable.textColor = UIColor(named: "labelColor")
        view.backgroundColor = UIColor(named: "whiteKasumi")
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let borderColor: UIColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        container.addBorder(toSide: .Bottom, withColor: borderColor.cgColor, andThickness: 1)
        container.addBorder(toSide: .Top, withColor: borderColor.cgColor, andThickness: 1)
    }
    
    private func configureUi(){
        view.addSubview(container)
        container.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16 , paddingLeft: 16, paddingRight: 16, height: 80)
        
        container.addSubview(imageRest)
        imageRest.anchor(left: container.leftAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 10, width: 40, height: 40)
        imageRest.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        container.addSubview(switchBtn)
        switchBtn.anchor(right: container.rightAnchor,  paddingRight: 10)
        switchBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        container.addSubview(lable)
        lable.anchor(left: imageRest.rightAnchor, paddingLeft: 10)
        lable.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Rest".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
   
    }
    

}
