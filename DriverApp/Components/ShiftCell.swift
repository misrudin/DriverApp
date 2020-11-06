//
//  ShiftCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 06/11/20.
//

import UIKit

class ShiftCell: UITableViewCell {
    
    static let id = "ShiftCell"
    
    var valueLabel: Int! {
        didSet {
            switch valueLabel {
            case 45:
                labelShit.text = "Shift 1"
            case 46:
                labelShit.text = "Shift 2"
            case 47:
                labelShit.text = "Shift 3"
            default:
                labelShit.text = "Shift 4"
            }
        }
    }
    
    let labelShit: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        return lable
    }()
    
    let viewContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "yellowKasumi")
        view.layer.cornerRadius = 10
        view.dropShadow(color: UIColor.black, offSet: CGSize(width: 1, height: 1))
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(viewContainer)
        viewContainer.addSubview(labelShit)
        selectionStyle = .none
        
        viewContainer.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        labelShit.anchor(top: viewContainer.topAnchor, left: viewContainer.leftAnchor, bottom: viewContainer.bottomAnchor, right: viewContainer.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
