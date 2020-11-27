//
//  OrderCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit

class OrderCell: UITableViewCell {
    static let id = "OrderCell"
    var orderVm = OrderViewModel()
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lableOrderNo: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var lableDate: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var originMarker: UIImageView!
    @IBOutlet weak var destinationMarker: UIImageView!
    @IBOutlet weak var pockupLable: UILabel!
    @IBOutlet weak var addresPickup: UILabel!
    @IBOutlet weak var deliveryLable: UILabel!
    @IBOutlet weak var deliveyAddress: UILabel!
    
    
    var orderData: NewOrderData! {
        didSet {
            guard let orderDetail = orderVm.decryptOrderDetail(data: orderData.order_detail, OrderNo: orderData.order_number),
                  let userInfo = orderVm.decryptUserInfo(data: orderData.user_info, OrderNo: orderData.order_number) else {
                return
            }
            
            orderNo.text = orderData.order_number

            let df = DateFormatter()
            let activeDate = Date.dateFromCustomString(customString: orderData.active_date)
            df.dateFormat = "dd MMM yyyy"
            let activeDateStr = df.string(from: activeDate)

            date.text = activeDateStr

            var arrayOfStore: [String] = []
            for item in orderDetail.pickup_destination {
                arrayOfStore.append(item.pickup_store_name)
            }
            addresPickup.text = arrayOfStore.joined(separator: " - ")
            
            deliveyAddress.text = "〒\(userInfo.postal_code) \(userInfo.prefecture) \(userInfo.chome) \(userInfo.address) \(userInfo.kana_after_address) \(userInfo.first_name) \(userInfo.last_name) \(userInfo.phone_number)"
        }
    }
    

    override func awakeFromNib() {
       super.awakeFromNib()
       
        selectionStyle = .none
        container.layer.cornerRadius = 5
        container.backgroundColor = .white
        container.dropShadow(color: UIColor(named: "grayKasumi")!, offSet: CGSize(width: 2, height: 2))
        backgroundColor = UIColor(named: "grayKasumi")
    }
    
    
    private func configureLayout(){
        lableDate.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        lableOrderNo.translatesAutoresizingMaskIntoConstraints = false
        orderNo.translatesAutoresizingMaskIntoConstraints = false
        originMarker.translatesAutoresizingMaskIntoConstraints = false
        destinationMarker.translatesAutoresizingMaskIntoConstraints = false
        pockupLable.translatesAutoresizingMaskIntoConstraints = false
        addresPickup.translatesAutoresizingMaskIntoConstraints = false
        deliveryLable.translatesAutoresizingMaskIntoConstraints = false
        deliveyAddress.translatesAutoresizingMaskIntoConstraints = false
        
//        lableOrderNo.topLeft(toView: container, top: 5, left: 5)
//        orderNo.top(toView: container)
//
//        originMarker.top(toView: lableOrderNo, space: 10)
//        originMarker.left(toView: container, space: 5)
        
    }
    
    
}
