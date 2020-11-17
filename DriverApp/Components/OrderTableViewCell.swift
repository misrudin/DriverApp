//
//  OrderTableViewCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit

@available(iOS 13.0, *)
class OrderTableViewCell: UITableViewCell {
    
    static let id = "OrderTableViewCell"
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(named: "grayKasumi")
        container.layer.cornerRadius = 5
//        container.addSubview(backgroundV)
        container.addSubview(labelOrder)
        container.addSubview(imagePin)
        container.addSubview(labelAdres)
        container.addSubview(labelAdresDetail)
        return container
    }()
    
    let labelOrder: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let labelAdres: UILabel = {
       let label = UILabel()
        label.text = "DELIVERY ADDRESS"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let labelAdresDetail: UILabel = {
       let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    lazy var imagePin: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "mappin.and.ellipse")
        image.tintColor = .orange
        return image
    }()
  

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(containerView)
        configureLayout()
        
        selectionStyle = .none
    }
    
    func configureLayout(){
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        labelOrder.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        imagePin.anchor(top: labelOrder.bottomAnchor, left: containerView.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 25, height: 25)
        labelAdres.anchor(top: labelOrder.bottomAnchor,
                          left: imagePin.rightAnchor,
                          right: containerView.rightAnchor,
                          paddingTop: 10,
                          paddingLeft: 10,
                          paddingRight: 10)

        labelAdresDetail.anchor(top:labelAdres.bottomAnchor,
                                left: imagePin.rightAnchor,
//                                bottom: containerView.bottomAnchor,
                                right: containerView.rightAnchor,
                                paddingTop: 5,
//                                paddingBottom: 10,
                                paddingLeft: 10,
                                paddingRight: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
