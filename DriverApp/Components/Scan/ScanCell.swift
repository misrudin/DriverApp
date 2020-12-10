//
//  ScanCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 27/11/20.
//

import UIKit

class ScanCell: UITableViewCell {
    
    static let id = "ScanCell"
    
    var item: PickupItem! {
        didSet {
            name.text = item.item_name
//            code.text = "Code : \(item.qr_code_raw)"
            print(item.qr_code_raw)
            status.text = item.scan != nil ? "Verified" : "Unverified"
            let colorU = UIColor(named: "orangeKasumi")
            let colorV = UIColor(named: "colorGreen")
            if item.scan != nil {
                line.backgroundColor = colorV
                container.layer.borderColor = colorV?.cgColor
                status.textColor = colorV
                name.textColor = colorV
//                code.textColor = colorV
            }else {
                line.backgroundColor = colorU
                container.layer.borderColor = colorU?.cgColor
                status.textColor = colorU
                name.textColor = colorU
//                code.textColor = colorU
            }
        }
    }

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        configureUi()
    }
    
    private func configureUi(){
        line.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        container.backgroundColor = .white
        line.backgroundColor = UIColor(named: "orangeKasumi")
        container.layer.cornerRadius = 5
        line.layer.cornerRadius = 5/2
        line.widthAnchor.constraint(equalToConstant: 5).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
