//
//  ShiftCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 06/11/20.
//

import UIKit

class ShiftCell: UITableViewCell {
    
    static let id = "ShiftCell"
    
//    var valueLabel: Int! {
//        didSet {
//            switch valueLabel {
//            case 1:
//                labelShit.text = "Shift 1"
//            case 2:
//                labelShit.text = "Shift 2"
//            case 3:
//                labelShit.text = "Shift 3"
//            default:
//                labelShit.text = "Shift 4"
//            }
//        }
//    }
    
    var shiftTime: ShiftTime! {
        didSet {
            lableShift.text = shiftTime.label_data
            lableTime.text = "\(shiftTime.time_start_shift[...4]) - \(shiftTime.time_end_shift[...4])"
        }
    }

    lazy var lableShift = Reusable.makeLabel(font: UIFont.systemFont(ofSize: 18, weight: .semibold), color: UIColor(named: "colorRed")!)
    lazy var lableTime = Reusable.makeLabel(font: UIFont.systemFont(ofSize: 16, weight: .regular), color: UIColor.black)
    
    let line: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.cornerRadius = 5
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        v.backgroundColor = UIColor(named: "colorRed")
        return v
    }()
    
    let viewContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "colorRed2")
        view.layer.cornerRadius = 5
        view.dropShadow(color: UIColor.black, offSet: CGSize(width: 1, height: 1))
        return view
    }()
    
    let leftView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "colorRed")
        v.roundCorners([.topLeft, .bottomLeft], radius: 5)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(viewContainer)
        viewContainer.addSubview(lableShift)
        viewContainer.addSubview(lableTime)
//        viewContainer.addSubview(leftView)
        viewContainer.insertSubview(leftView, at: 0)
        viewContainer.addSubview(line)
        selectionStyle = .none
        backgroundColor = .clear
        
        line.anchor(top: viewContainer.topAnchor, left: viewContainer.leftAnchor, bottom: viewContainer.bottomAnchor, width: 10)
        
        viewContainer.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingTop: 5 ,paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
        leftView.anchor(top: viewContainer.topAnchor, left: viewContainer.leftAnchor, bottom: viewContainer.bottomAnchor, width: 5)
        
        lableShift.anchor(top: viewContainer.topAnchor, left: leftView.rightAnchor, right: viewContainer.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        lableTime.anchor(left: leftView.rightAnchor, bottom: viewContainer.bottomAnchor, right: viewContainer.rightAnchor, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
