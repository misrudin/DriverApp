//
//  HistoryCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 29/11/20.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let id = "HistoryCell"
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderNoLable: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var receiverLable: UILabel!
    @IBOutlet weak var receiver: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var marker: UIImageView!
    
    lazy var orderVm = OrderViewModel()

    var item: History! {
        didSet {
            orderNo.text = item.order_number
            
            
            guard let orderDetail = orderVm.decryptOrderDetail(data: item.order_detail, OrderNo: item.order_number),
                  let userInfo = orderVm.decryptUserInfo(data: item.user_info, OrderNo: item.order_number) else {
                return
            }
            
            let df = DateFormatter()
            let activeDate = Date.dateFromCustomString(customString: item.active_date)
            df.dateFormat = "dd MMM yyyy"
            let activeDateStr = df.string(from: activeDate)

            date.text = activeDateStr

            var arrayOfStore: [String] = []
            for item in orderDetail.pickup_destination {
                arrayOfStore.append(item.pickup_store_name)
            }
            
            address.text = "〒\(userInfo.postal_code) \(userInfo.prefecture) \(userInfo.chome) \(userInfo.address) \(userInfo.kana_after_address) \(userInfo.first_name) \(userInfo.last_name) \(userInfo.phone_number)"
            
            status.text = "Done Delivery"
            
            receiver.text = "\(userInfo.first_name) \(userInfo.last_name)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.layer.cornerRadius = 10
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
