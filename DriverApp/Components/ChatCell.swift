//
//  ChatCell.swift
//  UITableViewChat
//
//  Created by BMG MacbookPro on 10/10/20.
//

import UIKit

@available(iOS 13.0, *)
class ChatCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    let bubleBackgroundView = UIView()
    
    let imageViewMsg: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    var leading: NSLayoutConstraint!
    var trailing: NSLayoutConstraint!
//    var heightLabel: NSLayoutConstraint!
//    var widthLabel: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet{
            bubleBackgroundView.backgroundColor = chatMessage.isIncoming ? .white : UIColor(named: "orangeKasumi")
            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
            timeLabel.textColor = chatMessage.isIncoming ? UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2) : UIColor.white
            
            messageLabel.text = chatMessage.text
            timeLabel.text = chatMessage.time
            
            if chatMessage.isIncoming {
                trailing.isActive = true
                leading.isActive = false
            }else {
                leading.isActive = true
                trailing.isActive = false
            }
            
            if chatMessage.photo != "" {
                messageLabel.text = "Photo Message - Click to preview."
                messageLabel.textColor = UIColor(named: "colorRed")
            }
            
//            if chatMessage.photo != "" {
//                if let stringPhoto = chatMessage.photo {
//                    let newImageData = Data(base64Encoded: stringPhoto)
//                    if let image = newImageData {
//                        imageViewMsg.image = UIImage(data: image)
//                    }
//                }
////                widthLabel.isActive = true
//                imageViewMsg.isHidden = false
////                heightLabel.isActive = true
//            }else{
//                imageViewMsg.isHidden = true
////                widthLabel.isActive = false
////                heightLabel.isActive = false
//            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        bubleBackgroundView.backgroundColor = .red
        bubleBackgroundView.layer.cornerRadius = 16
        bubleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(bubleBackgroundView)
        
        addSubview(messageLabel)
        addSubview(timeLabel)
        messageLabel.numberOfLines = 0
        
        
        // contraints for message label
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            
            messageLabel.topAnchor.constraint(equalTo: topAnchor,constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -35),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: frame.size.width-50),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            bubleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor,constant: -10),
            bubleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor,constant: -10),
            bubleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 25),
            bubleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor,constant: 10),
            
            timeLabel.bottomAnchor.constraint(equalTo: bubleBackgroundView.bottomAnchor, constant: -10),
            timeLabel.trailingAnchor.constraint(equalTo: bubleBackgroundView.trailingAnchor, constant: -10),
            
        ]
        
        
        
        NSLayoutConstraint.activate(constraints)
        
        leading = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 32)
        leading.isActive = false
        trailing = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -32)
        trailing.isActive = false
//        widthLabel = imageViewMsg.heightAnchor.constraint(equalToConstant: 200)
//        widthLabel.isActive = false
//        heightLabel = imageViewMsg.widthAnchor.constraint(equalToConstant: 200)
//        heightLabel.isActive = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
