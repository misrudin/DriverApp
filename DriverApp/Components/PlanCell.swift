//
//  PlanCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 16/11/20.
//

import UIKit

class PlanCell: UICollectionViewCell {
    static let id = "PlanCell"
    
    let dayLable = Reusable.makeLabel(font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .black, alignment: .center)
    let weekLabel = Reusable.makeLabel(text: "w1",font: UIFont.systemFont(ofSize: 10, weight: .regular), color: .black, alignment: .center)
    
    let container: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let container2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "colorGray")
        view.layer.cornerRadius = 5
    
        return view
    }()
    
    let dateLable: UILabel = {
        let lable = UILabel()
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
        view.backgroundColor = UIColor(named: "colorBlue")
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    let borderBotomSelected: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "colorRed")
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        

        contentView.addSubview(container)
        container.addSubview(dayLable)
        container.addSubview(container2)
        container2.addSubview(dateLable)
        container2.addSubview(statusLable)
        container2.addSubview(weekLabel)
        container.addSubview(borderBotom)
        container.addSubview(borderBotomSelected)
        
        

        container.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        
        dayLable.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor)
        
        
        borderBotom.anchor(left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, height: 5)
        borderBotomSelected.anchor(left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, height: 5)
        
        container2.anchor(top: dayLable.bottomAnchor, left: container.leftAnchor, bottom: borderBotom.topAnchor, right: container.rightAnchor, paddingTop: 5, paddingBottom: 5)
        
        dateLable.anchor(top: container2.topAnchor, left: container2.leftAnchor, right: container2.rightAnchor, paddingTop: 10)
        statusLable.anchor(top: dateLable.bottomAnchor, left: container2.leftAnchor, right: container2.rightAnchor, paddingTop: 10)
        
        weekLabel.anchor(top: container2.topAnchor, right: container2.rightAnchor, paddingTop: 4, paddingRight: 4, width: 10, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
