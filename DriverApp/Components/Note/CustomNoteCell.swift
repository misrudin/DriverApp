//
//  CustomNoteCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 22/12/20.
//

import UIKit
import LanguageManager_iOS

class CustomNoteCell: UITableViewCell {
    static let id  = "CustomNoteCell"
    @IBOutlet weak var orderno: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var deliverTo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var container: UIView!
    
    var orderVm = OrderViewModel()
    
    var item: Note! {
        didSet{
            let user = item.detail_order.user_info
            guard let orderNo = item.meta_data?.order_number,
                  let userInfo = orderVm.decryptUserInfo(data: user, OrderNo: orderNo) else {
                return
            }
            orderno.text = orderNo
            status.text = "Pending".localiz()
            date.text = item.created_date
            name.text = "\(userInfo.first_name) \(userInfo.last_name)"
            address.text = "\(userInfo.address)"
            note.text = item.note
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        container.backgroundColor = UIColor(named: "bgKasumi")
        container.layer.cornerRadius = 10
        orderNoLabel.text = "Order No".localiz()
        statusLabel.text = "Status".localiz()
        dateLabel.text = "Date".localiz()
        deliverTo.text = "Delivery To".localiz()
        
        
    }

    
}
