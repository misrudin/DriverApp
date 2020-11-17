//
//  NoteCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 23/10/20.
//

import UIKit

@available(iOS 13.0, *)
class NoteCell: UITableViewCell {
    
    static let id = "NoteCell"
    
    let labelNote: UILabel = {
       let lable = UILabel()
        lable.font = .systemFont(ofSize: 16)
        lable.textColor = .black
        lable.numberOfLines = 2
        return lable
    }()
    
    lazy var borderView = UIView()
    
    let labelTime: UILabel = {
       let lable = UILabel()
        lable.font = .systemFont(ofSize: 14)
        lable.textColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5)
        return lable
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(labelTime)
        addSubview(labelNote)
        addSubview(borderView)
        
        selectionStyle = .none
        
        configureLayout()
    }
    
    
    func configureLayout(){
        labelTime.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        labelNote.anchor(top: labelTime.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        
        borderView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        borderView.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
