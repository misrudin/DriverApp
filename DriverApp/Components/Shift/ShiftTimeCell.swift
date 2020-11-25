//
//  ShiftTimeCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 25/11/20.
//

import UIKit

class ShiftTimeCell: UICollectionViewCell {
    static let id = "ShiftTimeCell"
    
    let lableName = Reusable.makeLabel(text: "", font: UIFont.systemFont(ofSize: 15), color: UIColor(named: "colorBlue")!, alignment: .center)

    var shift: CustomList! {
        didSet{
            if shift.selected {
                container.backgroundColor = UIColor(named: "colorBlue")
                lableName.textColor = .white
            }else {
                container.backgroundColor = UIColor(named: "colorBlue2")
                lableName.textColor = UIColor(named: "colorBlue")
            }
        }
    }
    
    let container: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "colorBlue2")
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor(named: "colorBlue")?.cgColor
        v.layer.cornerRadius = 20
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(container)
        container.addSubview(lableName)
        
        container.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 0)
        lableName.translatesAutoresizingMaskIntoConstraints = false
        lableName.center(toView: container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
