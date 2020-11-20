//
//  PlanCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 16/11/20.
//

import UIKit

class PlanCell: UICollectionViewCell {
    static let id = "PlanCell"
    
    let dayLable: UILabel = {
        let lable = UILabel()
        lable.text = "Senin"
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lable.textAlignment = .center
    
        return lable
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    
    let dateLable: UILabel = {
        let lable = UILabel()
        lable.text = "01"
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textAlignment = .center
    
        return lable
    }()
    
    let statusLable: UILabel = {
        let lable = UILabel()
        lable.text = "Day Off"
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lable.textAlignment = .center
    
        return lable
    }()
    
    let borderBotom: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
//        contentView.backgroundColor = .red
        
        contentView.addSubview(dayLable)
        contentView.addSubview(container)
        container.addSubview(dateLable)
        container.addSubview(statusLable)
        contentView.addSubview(borderBotom)
        
        dayLable.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
        container.anchor(top: dateLable.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        borderBotom.anchor(top: container.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
