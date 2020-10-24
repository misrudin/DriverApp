//
//  NoteCell.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 23/10/20.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let id = "NoteCell"
    
    let labelNote: UILabel = {
       let lable = UILabel()
        lable.text = "heloo"
        lable.font = .systemFont(ofSize: 14)
        lable.textColor = .black
        lable.numberOfLines = 4
        return lable
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(labelNote)
        
        labelNote.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
