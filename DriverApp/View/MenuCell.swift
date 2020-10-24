//
//  MenuCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

class MenuCell: UITableViewCell {
    static let id = "MenuCell"
    
    let iconImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints=false
        image.tintColor = .white
        return image
    }()
    
    let menuLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Menu 1"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .darkGray
        selectionStyle = .none
        
        addSubview(iconImageView)
        addSubview(menuLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor,constant: 12),
            menuLabel.rightAnchor.constraint(equalTo: rightAnchor,constant: -12),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
