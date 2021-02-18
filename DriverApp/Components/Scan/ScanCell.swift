//
//  ScanCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 27/11/20.
//

import UIKit
import LanguageManager_iOS

class ScanCell: UITableViewCell {
    
    static let id = "ScanCell"
    
    var constraint: NSLayoutConstraint!
    
    var item: PickupItem! {
        didSet {
            name.text = item.box_name
            print(item.qr_code_url)
            status.text = item.scan != nil ? "Verified".localiz() : "Unverified".localiz()
            scanButton.isHidden = item.scan != nil
            let colorU = UIColor(named: "orangeKasumi")
            let colorV = UIColor(named: "colorGreen")
            if item.scan != nil {
                line.backgroundColor = colorV
                container.layer.borderColor = colorV?.cgColor
                status.textColor = colorV
                name.textColor = colorV
            }else {
                line.backgroundColor = colorU
                container.layer.borderColor = colorU?.cgColor
                status.textColor = colorU
                name.textColor = colorU
            }
        }
    }
    
    var clas: String! {
        didSet {
            clasification.text = clas
        }
    }
    
    var isBopis: Bool! {
        didSet {
            if isBopis {
                isDropBopis.text = "Drop BOPIS Box at This Store"
                constraint.isActive = false
            }else {
                isDropBopis.text = ""
                constraint.isActive = true
            }
        }
    }

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var clasification: UILabel!
    @IBOutlet weak var isDropBopis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        backgroundColor = .clear
        configureUi()
    }
    
    private func configureUi(){
        line.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        container.backgroundColor = UIColor(named: "whiteKAsumi")
        line.backgroundColor = UIColor(named: "orangeKasumi")
        container.layer.cornerRadius = 10
        line.layer.cornerRadius = 2
        line.widthAnchor.constraint(equalToConstant: 5).isActive = true
        scanButton.backgroundColor = UIColor(named: "darkKasumi")
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        scanButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        scanButton.layer.cornerRadius = 15
        scanButton.setTitle("Scan".localiz(), for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.isUserInteractionEnabled = false
        constraint = scanButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
