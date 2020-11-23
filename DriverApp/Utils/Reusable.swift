//
//  Reusable.swift
//  DriverApp
//
//  Created by Indo Office4 on 23/11/20.
//

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }

struct Reusable {
    //MARK: - Lable
    static func makeLabel(text: String? = nil, font: UIFont = .systemFont(ofSize: 15),
                          color: UIColor = .black, numberOfLines: Int = 1,
                          alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        label.text = text
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        return label
    }
    
    //MARK: - Button
    static func makeButton(text: String? = nil, font: UIFont = .systemFont(ofSize: 15),
                           color: UIColor = .black, background: UIColor = .white, rounded: CGFloat = 0) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2), for: .highlighted)
        button.layer.cornerRadius = rounded
        button.backgroundColor = background
        button.layer.masksToBounds = true
        button.titleLabel?.font = font
        button.isHidden = true
        return button
    }
    
    //MARK: - Input
    static func makeInput(placeholder: String = "", keyType: UIKeyboardType = .default, bg: UIColor = .white, radius: CGFloat = 0, autoKapital: UITextAutocapitalizationType = .none) -> UITextField {
        let field = UITextField()
        field.autocapitalizationType = autoKapital
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = radius
        field.placeholder = placeholder
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = bg
        field.returnKeyType = .continue
        field.keyboardType = keyType
        return field
    }
    
    //MARK: - Image View
    static func makeImageView(image: UIImage? = nil,
                              contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.clipsToBounds = true
        return iv
    }
}
