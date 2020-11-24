//
//  RestViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit

class RestViewController: UIViewController {
    
    let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var switchBtn: UISwitch = {
       let sw = UISwitch()
        sw.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return sw
    }()
    
    @objc func switchValueDidChange(sender:UISwitch!)
    {
        if (sender.isOn == true){
            print("on")
        }
        else{
            print("off")
        }
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
    
    lazy var lable = Reusable.makeLabel(text: "Activate rest now")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
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
        navigationItem.title = "Rest"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
   
    }
    

}
