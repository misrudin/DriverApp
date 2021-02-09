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
    
    var item: PickupItem! {
        didSet {
            name.text = item.item_name
            print(item.qr_code_raw)
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

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
