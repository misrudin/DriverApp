//
//  ScanCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 27/11/20.
//

import UIKit

class ScanCell: UITableViewCell {
    
    static let id = "ScanCell"
    
    var item: Scanned! {
        didSet {
            name.text = item.item_name
            code.text = "Code : \(item.qr_code_raw)"
            status.text = item.scanned_status > 0 ? "Verified" : "Unverified"
        }
    }

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureUi()
    }
    
    private func configureUi(){
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        container.backgroundColor = .white
        line.backgroundColor = UIColor(named: "orangeKasumi")
        container.layer.cornerRadius = 5
        line.layer.cornerRadius = 5/2
        line.translatesAutoresizingMaskIntoConstraints = false
        line.widthAnchor.constraint(equalToConstant: 5).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
