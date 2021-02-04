//
//  CustomCellChat.swift
//  DriverApp
//
//  Created by Indo Office4 on 15/12/20.
//

import UIKit

class CustomCellChat: UITableViewCell {
    
    static let id = "CustomCellChat"

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var contentChat: UILabel!
    
    @IBOutlet weak var timeChat: UILabel!
    
    var leading: NSLayoutConstraint!
    var trailing: NSLayoutConstraint!
    
    var item:
    ChatMessage! {
        didSet {
            leading.isActive = !item.isIncoming
            trailing.isActive = item.isIncoming
            timeChat.textColor = item.isIncoming ? UIColor(named: "labelSecondary") : UIColor.white
            contentChat.text = item.text
            timeChat.text = item.time
            contentChat.textColor = item.isIncoming ? UIColor(named: "labelColor") : .white
            container.backgroundColor =  item.isIncoming ? UIColor(named: "bubbleColor") : UIColor(named: "orangeKasumi")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()


        selectionStyle = .none
        backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.widthAnchor.constraint(lessThanOrEqualToConstant: frame.size.width-50).isActive = true
        container.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        leading = container.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16)
        leading.isActive = false
        trailing = container.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16)
        trailing.isActive = false
    }
    
    
    
    
    
}
