//
//  PendingCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 03/12/20.
//

import UIKit

class PendingCell: UITableViewCell {
    static let id  = "PendingCell"
    
    
    var pendingData: Note! {
        didSet {
            labelNote.text = pendingData.note
            orderNo.text = pendingData.meta_data?.order_number
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd MMM yyyy hh:mm"
            let dateVlue = dateFormater.date(from: "\(pendingData.created_date) \(pendingData.created_time)")
            let format = DateFormatter()
            format.dateFormat = "dd MMM yyyy hh:mm"
            
            let dateString = format.string(from: dateVlue!)
            
            date.text = dateString
        }
    }
    

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var labelOrderNo: UILabel!
    
    @IBOutlet weak var orderNo: UILabel!
    
    @IBOutlet weak var labelNote: UILabel!
    
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 5
        container.backgroundColor = .white
        
        backgroundColor = UIColor(named: "grayKasumi")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
