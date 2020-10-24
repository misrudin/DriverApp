//
//  ChatCell.swift
//  UITableViewChat
//
//  Created by BMG MacbookPro on 10/10/20.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubleBackgroundView = UIView()
    
    var leading: NSLayoutConstraint!
    var trailing: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet{
            bubleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor(named: "orangeKasumi") : .white
            messageLabel.textColor = chatMessage.isIncoming ? .white : .black
            
            messageLabel.text = chatMessage.text
            
            if chatMessage.isIncoming {
                leading.isActive = true
                trailing.isActive = false
            }else {
                trailing.isActive = true
                leading.isActive = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        bubleBackgroundView.backgroundColor = .red
        bubleBackgroundView.layer.cornerRadius = 16
        bubleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubleBackgroundView)
        
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        
        
        // contraints for message label
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            
            messageLabel.topAnchor.constraint(equalTo: topAnchor,constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor,constant: -16),
            bubleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor,constant: -16),
            bubleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 16),
            bubleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor,constant: 16),
            
        ]
        
        
        
        NSLayoutConstraint.activate(constraints)
        
        leading = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 32)
        
        trailing = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
