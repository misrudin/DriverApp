//
//  ImageCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 16/12/20.
//

import UIKit

class ImageCell: UITableViewCell {
    
    static let id = "ImageCell"
    
    @IBOutlet weak var imageChat: UIImageView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var chatContent: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var leading: NSLayoutConstraint!
    var trailing: NSLayoutConstraint!
    
    
    var item:
    ChatMessage! {
        didSet {
            leading.isActive = !item.isIncoming
            trailing.isActive = item.isIncoming
            timeLabel.textColor =  UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2)
            chatContent.text = item.text
            timeLabel.text = item.time
            chatContent.textColor = item.isIncoming ? .black : .white
            guard let imgString = item.photo else {
                return
            }
            var imageBase64 = imgString.replacingOccurrences(of: "data:image/png;base64,", with: " ")
            imageBase64 = imageBase64.replacingOccurrences(of: "data:image/jpg;base64,", with: " ")
            imageBase64 = imageBase64.replacingOccurrences(of: "data:image/svg;base64,", with: " ")
            imageBase64 = imageBase64.replacingOccurrences(of: "data:image/jpeg;base64,", with: " ")
            imageBase64 = imageBase64.replacingOccurrences(of: "data:image/gif;base64,", with: " ")
            imageBase64 = imageBase64.replacingOccurrences(of: "data:image/webp;base64,", with: " ")
            let imageData = Data(base64Encoded: imageBase64.trimmingCharacters(in: .whitespacesAndNewlines))
            imageChat.image = UIImage(data: imageData!)
//            imageChat.isHidden = true
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        imageChat.translatesAutoresizingMaskIntoConstraints = false
        imageChat.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor)
        container.layer.cornerRadius = 5
        imageChat.layer.cornerRadius = 5
        container.widthAnchor.constraint(equalToConstant: 250).isActive = true
        container.backgroundColor = .red
        leading = container.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16)
        leading.isActive = false
        trailing = container.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16)
        trailing.isActive = false
        
    }

    
}
