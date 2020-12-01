//
//  DetailView.swift
//  DriverApp
//
//  Created by Indo Office4 on 01/12/20.
//

import UIKit

class DetailView: UIViewController {
    
    var userInfo: NewUserInfo? = nil
    var orderDetail: NewOrderDetail? = nil
    
    lazy var pickupStore = Reusable.makeLabel(font: UIFont.systemFont(ofSize: 16, weight: .regular), color: UIColor(named: "darkKasumi")!, numberOfLines: 0)
    lazy var destination = Reusable.makeLabel(font: UIFont.systemFont(ofSize: 16, weight: .regular), color: UIColor(named: "darkKasumi")!, numberOfLines: 0)
    private func createTitle(title: String, icon: UIImage)-> UIView {
       let  v = UIView()
        let lable = UILabel()
        lable.text = title
        lable.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        lable.textColor = UIColor(named: "darkKasumi")
        
        let img: UIImageView = {
           let i = UIImageView()
            i.image = icon
            i.clipsToBounds = true
            i.layer.masksToBounds = true
            i.layer.cornerRadius = 10
            return i
        }()
        
        v.addSubview(lable)
        v.addSubview(img)
        
        img.anchor(left: v.leftAnchor, paddingLeft: 10, width: 20, height: 20)
        img.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        lable.anchor(top: v.topAnchor, left: img.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
       return v
    }
    
    lazy var title1 = createTitle(title: "Pickup Store", icon: UIImage(named: "originIcon")!)
    lazy var title2 = createTitle(title: "Delivery Location", icon: UIImage(named: "destinationIcon")!)
    
    lazy var container: UIStackView = {
       let v = UIStackView()
        v.backgroundColor = UIColor(named: "grayKasumi")
        v.layer.cornerRadius = 20
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        v.axis = .vertical
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        
        let list = orderDetail!.pickup_destination.map({ $0.pickup_store_name })
        
        
        pickupStore.text = list.joined(separator: " - ")
        destination.text = "〒\(userInfo!.postal_code) \(userInfo!.prefecture) \(userInfo!.chome) \(userInfo!.address) \(userInfo!.kana_after_address) \(userInfo!.first_name) \(userInfo!.last_name) \(userInfo!.phone_number)"

        view.backgroundColor = UIColor(named: "whiteKasumi")
        configureUi()
    }
    
    private func configureUi(){
        
        view.addSubview(title1)
        view.addSubview(pickupStore)
        view.addSubview(title2)
        view.addSubview(destination)
        
        title1.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        pickupStore.anchor(top: title1.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40+16, paddingRight: 16)
        title2.anchor(top: pickupStore.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        destination.anchor(top: title2.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40+16, paddingRight: 16)
    }

}
