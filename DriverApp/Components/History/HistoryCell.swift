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
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderNoLable: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var container: UIView!

    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var marker: UIImageView!
    
    
    let lableNothing = Reusable.makeLabel(text: "has not reviewed by admin", font: UIFont.systemFontItalic(size: 15), color: UIColor(named: "darkKasumi")!, alignment: .left)
    
    lazy var orderVm = OrderViewModel()

    var item: History! {
        didSet {
            orderNo.text = item.order_number
            
            let df = DateFormatter()
            let activeDate = Date.dateFromCustomString(customString: item.active_date)
            df.dateFormat = "dd MMM yyyy"
            let activeDateStr = df.string(from: activeDate)
            
            guard let timeDone = item.time_detail.time_done_delivery, let timeStart = item.time_detail.time_start_pickup  else {
                return
            }

            date.text = activeDateStr
            
            timeLabel.text = timeStart[...4] + " - " + timeDone[...4]


//            labelRating.text = "\(item.rating)"
            
            if let comment = item.comment {
                review.text = comment
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
                review.isHidden = false
                rating1.isHidden = false
                rating2.isHidden = false
                rating3.isHidden = false
                rating4.isHidden = false
                rating5.isHidden = false
                lableNothing.isHidden = true
            }else {
                review.isHidden = true
                rating1.isHidden = true
                rating2.isHidden = true
                rating3.isHidden = true
                rating4.isHidden = true
                rating5.isHidden = true
                lableNothing.isHidden = false
            }
            
            guard let userDetail = orderVm.decryptUserInfo(data: item.user_info, OrderNo: item.order_number) else {
                return
            }
            
            print(userDetail)
            nameLabel.text = "\(userDetail.first_name) \(userDetail.last_name)"
            addressLabel.text = "〒\(userDetail.postal_code) \(userDetail.prefecture) \(userDetail.chome) \(userDetail.address) \(userDetail.kana_after_address) \(userDetail.phone_number)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.layer.cornerRadius = 10
        container.addSubview(lableNothing)
        lableNothing.anchor(top: orderNo.bottomAnchor, left: container.leftAnchor, right: container.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingRight: 10)
        selectionStyle = .none
        date.font = UIFont.systemFont(ofSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
