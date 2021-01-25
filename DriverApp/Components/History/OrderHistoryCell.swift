//
//  OrderHistoryCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 22/12/20.
//

import UIKit
import LanguageManager_iOS

class OrderHistoryCell: UITableViewCell {
    
    static let id = "OrderHistoryCell"
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var orderno: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var marker: UIImageView!
    @IBOutlet weak var deliveryTo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rnr: UILabel!
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    @IBOutlet weak var rivew: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var nothing: UILabel!
    
    lazy var orderVm = OrderViewModel()
    
    var item: History! {
        didSet {
            orderno.text = item.order_number
            
            let df = DateFormatter()
            let activeDate = Date.dateFromCustomString(customString: item.active_date)
            df.dateFormat = "dd MMM yyyy"
            let activeDateStr = df.string(from: activeDate)
            
            guard let timeDone = item.time_detail.time_done_delivery, let timeStart = item.time_detail.time_start_pickup  else {
                return
            }

            date.text = activeDateStr
            
            time.text = "\(timeStart[...4] + " - " + timeDone[...4])"


//            labelRating.text = "\(item.rating)"
            
            if let comment = item.comment {
                rivew.text = comment
            }
            
            if item.rating == 0 {
                rating1.image = UIImage(named: "star2")
                rating2.image = UIImage(named: "star2")
                rating3.image = UIImage(named: "star2")
                rating4.image = UIImage(named: "star2")
                rating5.image = UIImage(named: "star2")
            }
            
            if item.rating > 0  && item.rating >= 1 {
                rating1.image = UIImage(named: "star")
                rating2.image = UIImage(named: "star2")
                rating3.image = UIImage(named: "star2")
                rating4.image = UIImage(named: "star2")
                rating5.image = UIImage(named: "star2")
            }
            
            if item.rating > 1  && item.rating >= 2 {
                rating1.image = UIImage(named: "star")
                rating2.image = UIImage(named: "star")
                rating3.image = UIImage(named: "star2")
                rating4.image = UIImage(named: "star2")
                rating5.image = UIImage(named: "star2")
            }
            
            if item.rating > 2  && item.rating >= 3 {
                rating1.image = UIImage(named: "star")
                rating2.image = UIImage(named: "star")
                rating3.image = UIImage(named: "star")
                rating4.image = UIImage(named: "star2")
                rating5.image = UIImage(named: "star2")
            }
            
            if item.rating > 3  && item.rating >= 4 {
                rating1.image = UIImage(named: "star")
                rating2.image = UIImage(named: "star")
                rating3.image = UIImage(named: "star")
                rating4.image = UIImage(named: "star")
                rating5.image = UIImage(named: "star2")
            }
            
            if item.rating > 4  && item.rating >= 5 {
                rating1.image = UIImage(named: "star")
                rating2.image = UIImage(named: "star")
                rating3.image = UIImage(named: "star")
                rating4.image = UIImage(named: "star")
                rating5.image = UIImage(named: "star")
            }
            
            if item.status_rating == false {
                rivew.isHidden = false
                rating1.isHidden = false
                rating2.isHidden = false
                rating3.isHidden = false
                rating4.isHidden = false
                rating5.isHidden = false
//                lableNothing.isHidden = true
                nothing.isHidden = true
            }else {
                rivew.isHidden = true
                rating1.isHidden = true
                rating2.isHidden = true
                rating3.isHidden = true
                rating4.isHidden = true
                rating5.isHidden = true
//                lableNothing.isHidden = false
                nothing.isHidden = false
            }
            
            guard let userDetail = orderVm.decryptUserInfo(data: item.user_info, OrderNo: item.order_number) else {
                return
            }
            
            name.text = "\(userDetail.first_name) \(userDetail.last_name)"
            address.text = "\(userDetail.address)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
//        MARK: - Value
        orderNoLabel.text = "Order No".localiz()
        dateLabel.text = "Date".localiz()
        statusLabel.text = "Status".localiz()
        timeLabel.text = "Delivery Time".localiz()
        deliveryTo.text = "Delivery To".localiz()
        rnr.text = "Rating and Review".localiz()
        nothing.text = "has not reviewed by admin".localiz()
        
        
        container.backgroundColor = UIColor(named: "bgKasumi")
        container.layer.cornerRadius = 5
    }

  
    
}
