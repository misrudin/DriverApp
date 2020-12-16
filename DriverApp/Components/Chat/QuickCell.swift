//
//  QuickCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 16/12/20.
//

import UIKit

@available(iOS 13.0, *)
class QuickCell: UITableViewCell {
    static let id = "QuickCell"
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var item1: UIView!
    @IBOutlet weak var item2: UIView!
    @IBOutlet weak var item3: UIView!
    @IBOutlet weak var item4: UIView!
    @IBOutlet weak var item5: UIView!
    @IBOutlet weak var lastItem: UIView!
    
    var vi = ChatView()
    
    var chatVm = ChatViewModel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.backgroundColor = .white
        
        item1.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item2.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item3.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item4.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item5.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        
        container.dropShadow(color: UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1), opacity: 0.1, offSet: CGSize(width: 0, height: 0), radius: 5, scale: true)
        
        lastItem.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        [item1,item2,item3,item4,item5].enumerated().forEach { (i, e) in
            e?.isUserInteractionEnabled = true
            let tap = CustomTap(target: self, action: #selector(tapQuickChat))
            tap.ourCustomValue = i
            e?.addGestureRecognizer(tap)
        }
        
    }
    
    @objc func tapQuickChat(sender: CustomTap){
        let messages:[String] = [
        "Hello", "Address cannot be found", "Person not at home", "Package not correct", "I have an accidents"
        ]
        
        guard let index = sender.ourCustomValue as? Int else {
            return
        }
        
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        let chat = messages[index]
        NotificationCenter.default.post(name: .didSendMessage, object: nil)
        
        chatVm.sendMessage(codeDriver: codeDriver, chat: chat) { (res) in
            if res {
                print("Succes to sen \(messages[index])")
            }else{
                print("sen message falied")
            }
        }
        
    }

}
