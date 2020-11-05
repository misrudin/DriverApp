//
//  ActionCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 02/11/20.
//

import UIKit

class ActionCell: UITableViewCell {
    
    static let id = "ActionCell"

    let lableAction: UILabel = {
       let label = UILabel()
        label.text = "siaa"
        label.font = UIFont.systemFont(ofSize: 15,weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let container: UIView = {
       let view = UIView()
        return view
    }()
    
    let arrowIcon: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(systemName: "chevron.right")
        img.layer.masksToBounds = true
        img.contentMode = .right
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        container.addSubview(lableAction)
        container.addSubview(arrowIcon)
        selectionStyle = .none
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        lableAction.anchor(left: container.leftAnchor, right: arrowIcon.leftAnchor)
        lableAction.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive=true
        arrowIcon.anchor(top: container.topAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingRight: 10, width: 50)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
