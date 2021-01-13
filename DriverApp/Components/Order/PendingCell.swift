//
//  PendingCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 03/12/20.
//

import UIKit
import LanguageManager_iOS

class PendingCell: UITableViewCell {
    static let id  = "PendingCell"
    
    //    MARK: - Data
    var orderVm = OrderViewModel()
    
    var orderData: NewOrderData! {
        didSet {
            
            
            guard let orderDetail = orderVm.decryptOrderDetail(data: orderData.order_detail, OrderNo: orderData.order_number) else {
                return
            }
            
            orderNo.text = ": \(orderData.order_number)"
            
            let start = orderData.detail_shift.time_start_shift[...4]
            let end = orderData.detail_shift.time_end_shift[...4]
             
            
            DispatchQueue.main.async {
                if self.orderData.pending_by_system! {
                    self.container.backgroundColor = UIColor(named: "colorGray")
                    self.status.text = "Pending by System".localiz()
                }else {
                    self.container.backgroundColor = UIColor(named: "colorDisabled")
                    self.status.text = "Pending".localiz()
                }
            }

            self.isUserInteractionEnabled = orderData.pending_by_system!

            date.text = "\(start) - \(end)"

            var arrayOfStore: [String] = []
            for item in orderDetail.pickup_destination {
                arrayOfStore.append(item.pickup_store_name)
            }
            pickupAddress.text = arrayOfStore.joined(separator: " - ")
            
            guard let userInfo = orderVm.decryptUserInfo(data: orderData.user_info, OrderNo: orderData.order_number) else {
                return
            }
            
            deliveryAddress.text = "〒\(userInfo.postal_code) \(userInfo.prefecture) \(userInfo.chome) \(userInfo.address) \(userInfo.kana_after_address) \(userInfo.first_name) \(userInfo.last_name) \(userInfo.phone_number)"
        }
    }
    
    //    MARK: - Components
    let orderNoLabel = Reusable.makeLabel(text: "Order No".localiz(), font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "darkKasumi")!, alignment: .left)
    let orderNo = Reusable.makeLabel(text: "1111", font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "orangeKasumi")!, alignment: .left)
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "colorGray")
        view.layer.cornerRadius = 5
        return view
    }()
    let statusLabel = Reusable.makeLabel(text: "Status".localiz(), font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "darkKasumi")!)
    let status = Reusable.makeLabel(text: "Pending".localiz(), font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "darkKasumi")!)

    let date = Reusable.makeLabel(text: "2020-10-10", font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "darkKasumi")!)
    
    let imageMarker: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "originMarker")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let pickupStore = Reusable.makeLabel(text: "PickUp Address".localiz(), font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "darkKasumi")!, numberOfLines: 0)
    let pickupAddress = Reusable.makeLabel(text: "Lorem ipsum", font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "darkKasumi")!, numberOfLines: 0)
    
    let imageMarker2: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "destinationMarker")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let delivaryLabel = Reusable.makeLabel(text: "Delivery To".localiz(), font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "darkKasumi")!, numberOfLines: 0)
    let deliveryAddress = Reusable.makeLabel(text: "Lorem ipsum", font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "darkKasumi")!, numberOfLines: 0)

    
    
    //    MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(views: orderNoLabel, orderNo, container)
        container.addSubviews(views: statusLabel,
                              status,
                              date,
                              imageMarker,
                              imageMarker2,
                              pickupStore,
                              pickupAddress,
                              delivaryLabel,
                              deliveryAddress)
        configureUi()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Stying
    private func configureUi(){
        orderNo.translatesAutoresizingMaskIntoConstraints = false
        
        orderNoLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        orderNo.centerY(toAnchor: orderNoLabel.centerYAnchor)
        orderNo.left(toAnchor: orderNoLabel.rightAnchor, space: 5)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.top(toAnchor: orderNoLabel.bottomAnchor, space: 10)
        container.left(toAnchor: leftAnchor, space: 10)
        container.right(toAnchor: rightAnchor, space: -10)
        container.bottom(toAnchor: bottomAnchor, space: -10)
        
        ///inside container
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.top(toAnchor: container.topAnchor, space: 10)
        statusLabel.left(toAnchor: container.leftAnchor, space: 5)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.centerY(toAnchor: statusLabel.centerYAnchor)
        status.left(toAnchor: statusLabel.rightAnchor, space: 10)
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.top(toAnchor: container.topAnchor, space: 10)
        date.right(toAnchor: container.rightAnchor, space: -5)
        
        imageMarker.anchor(top: statusLabel.bottomAnchor, left: container.leftAnchor, paddingTop: 10, paddingLeft: 5, width: 20, height: 20)
        pickupStore.translatesAutoresizingMaskIntoConstraints = false
        pickupAddress.translatesAutoresizingMaskIntoConstraints = false
        pickupStore.centerY(toAnchor: imageMarker.centerYAnchor)
        pickupStore.left(toAnchor: imageMarker.rightAnchor, space: 5)
        pickupAddress.top(toAnchor: pickupStore.bottomAnchor, space: 5)
        pickupAddress.left(toAnchor: imageMarker.rightAnchor, space: 5)
        pickupAddress.right(toAnchor: container.rightAnchor, space: -5)
        pickupStore.right(toAnchor: container.rightAnchor, space: -5)
        
        imageMarker2.anchor(top: pickupAddress.bottomAnchor, left: container.leftAnchor, paddingTop: 10, paddingLeft: 5, width: 20, height: 20)
        delivaryLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryAddress.translatesAutoresizingMaskIntoConstraints = false
        delivaryLabel.centerY(toAnchor: imageMarker2.centerYAnchor)
        delivaryLabel.left(toAnchor: imageMarker2.rightAnchor, space: 5)
        deliveryAddress.top(toAnchor: delivaryLabel.bottomAnchor, space: 5)
        deliveryAddress.left(toAnchor: imageMarker2.rightAnchor, space: 5)
        deliveryAddress.right(toAnchor: container.rightAnchor, space: -5)
        delivaryLabel.right(toAnchor: container.rightAnchor, space: -5)
        deliveryAddress.bottom(toAnchor: container.bottomAnchor, space: -10)
    }
}
