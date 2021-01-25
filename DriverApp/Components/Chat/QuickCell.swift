//
//  QuickCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 16/12/20.
//

import UIKit
import LanguageManager_iOS

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
    @IBOutlet weak var item6: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UIView!
    
    var vi = ChatView()
    
    var chatVm = ChatViewModel()
    var messages:[String] = [
        "Hello".localiz(), "Address cannot be found".localiz(), "Person not at home".localiz(), "Package not correct".localiz(), "I have an accidents".localiz()
    ]
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.backgroundColor = .white
    
        label1.text = "Hello".localiz()
        label2.text = "Address cannot be found".localiz()
        label3.text = "Person not at home".localiz()
        label4.text = "Package not correct".localiz()
        label5.text = "I have an accidents".localiz()
        label5.text = "Other".localiz()
        item1.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item2.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item3.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item4.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item5.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        item6.addBorder(toSide: .Top, withColor: UIColor(named: "grayKasumi")!.cgColor, andThickness: 1)
        
        container.dropShadow(color: UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1), opacity: 0.1, offSet: CGSize(width: 0, height: 0), radius: 5, scale: true)
        
        lastItem.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        [item1,item2,item3,item4,item5].enumerated().forEach { (i, e) in
            e?.isUserInteractionEnabled = true
            let tap = CustomTap(target: self, action: #selector(tapQuickChat))
            tap.ourCustomValue = i
            e?.addGestureRecognizer(tap)
        }
        
        item6.isUserInteractionEnabled = true
        item6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(otherClick)))
        
    }
    
    @objc private func otherClick(){
        NotificationCenter.default.post(name: .didOtherClick, object: nil)
    }
    
    @objc func tapQuickChat(sender: CustomTap){
        
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
                print("Succes to sen \(self.messages[index])")
            }else{
                print("sen message falied")
            }
        }
        
    }

}
