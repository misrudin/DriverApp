//
//  OrderCell.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit
import LanguageManager_iOS

class OrderCell: UITableViewCell {
    static let id = "OrderCell"
    var orderVm = OrderViewModel()
    
    
    //MARK: - Setter
    
    var shift: ShiftTime! {
        didSet {
            let start = shift.time_start_shift[...4]
            let end = shift.time_end_shift[...4]
            date.text = "\(start) - \(end)"
        }
    }
    
    var deliveryData: NewDelivery! {
        didSet {
            orderNo.text = ": \(deliveryData.order_number)"
            
            guard let userInfo = orderVm.decryptUserInfo(data: deliveryData.user_info!, OrderNo: deliveryData.order_number) else {
                return
            }
            
            pickupAddress.text = "\(userInfo.first_name) \(userInfo.last_name), \(userInfo.address)"
            
            if deliveryData.status_tracking == "wait for pickup" {
                self.visualEffectView.isHidden = false
            }else {
                self.visualEffectView.isHidden = true
            }
        }
    }
    
    //    MARK: - Components
    let orderNoLabel = Reusable.makeLabel(text: "Order No".localiz(), font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "labelColor")!, alignment: .left)
    let orderNo = Reusable.makeLabel(text: "1111", font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "labelColor")!, alignment: .left)
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bgOrderActive")
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()

    let date = Reusable.makeLabel(font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "labelColor")!)
    
    let imageMarker: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "destinationMarker")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let pickupStore = Reusable.makeLabel(text: "Delivery Address".localiz(), font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "labelColor")!, numberOfLines: 0)
    let pickupAddress = Reusable.makeLabel(font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "labelColor")!, numberOfLines: 0)
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        return view
    }()

    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews(views: orderNoLabel, orderNo, container)
        container.addSubviews(views:
                              date,
                              imageMarker,
                              pickupStore,
                              pickupAddress, visualEffectView)
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
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.top(toAnchor: container.topAnchor, space: 10)
        date.right(toAnchor: container.rightAnchor, space: -5)
        
        imageMarker.anchor(top: container.topAnchor, left: container.leftAnchor, paddingTop: 10, paddingLeft: 5, width: 20, height: 20)
        pickupStore.translatesAutoresizingMaskIntoConstraints = false
        pickupAddress.translatesAutoresizingMaskIntoConstraints = false
        pickupStore.centerY(toAnchor: imageMarker.centerYAnchor)
        pickupStore.left(toAnchor: imageMarker.rightAnchor, space: 5)
        pickupAddress.top(toAnchor: pickupStore.bottomAnchor, space: 5)
        pickupAddress.left(toAnchor: imageMarker.rightAnchor, space: 5)
        pickupAddress.right(toAnchor: container.rightAnchor, space: -5)
        pickupStore.right(toAnchor: container.rightAnchor, space: -5)
        
        pickupAddress.bottom(toAnchor: container.bottomAnchor, space: -10)
        
        visualEffectView.fill(toView: container)
        visualEffectView.clipsToBounds = true
    }
    
}
