//
//  DayOffViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import FirebaseCrashlytics

class DayOffViewController: UIViewController {
    
    let months: [String] = ["January","February","Maret","April","Mei","Juni","July","Agustus","September","Oktober","November","Desember"]
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = months[Calendar.current.component(.month, from: Date())-1]
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var scView:UIScrollView!
    let buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10

    
    let contrainerView: UIView = {
        let view=UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        
        scView = UIScrollView()
        view.addSubview(scView)
        scView.isScrollEnabled = true
        scView.alwaysBounceHorizontal = false
        scView.showsHorizontalScrollIndicator = false
        scView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10,height: 100)
        view.addSubview(contrainerView)
        scView.translatesAutoresizingMaskIntoConstraints = false
        let daysInMounth = Date().daysInMonth()
        
        for i in 1 ... daysInMounth {
            let button = UIView()
            let container = UIView()
            let labelDay = UILabel()
            let labelDesc = UILabel()
            let labelDate = UILabel()
            
            labelDay.text = Date.dayNameFromCustomDate(customDate: i)
            labelDay.textAlignment = .center
            labelDesc.textAlignment = .center
            
            labelDate.textColor = .white
            labelDate.text = "\(i)"
            labelDate.textAlignment = .center
            
           
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.darkGray
            let customTap = CustomTap(target: self, action: #selector(btnTouch(sender:)))
            customTap.ourCustomValue = Date.dateStringFrom(customDate: i)
            button.addGestureRecognizer(customTap)
            container.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 80, height: 80)
            
            xOffset = xOffset + CGFloat(buttonPadding) + container.frame.size.width
            scView.addSubview(container)
            container.addSubview(labelDay)
            container.addSubview(button)
            button.addSubview(labelDesc)
            button.addSubview(labelDate)
            labelDay.font = UIFont.systemFont(ofSize: 16,weight: .bold)
            labelDesc.text = "Day Off"
            labelDesc.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            labelDesc.textColor = .white
            
            labelDay.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor, height: 20)
            button.anchor(top: labelDay.bottomAnchor, left: container.leftAnchor,bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 5)
            labelDate.anchor(top: button.topAnchor, left: button.leftAnchor, right: button.rightAnchor, paddingTop: 6,height: 20)
            labelDesc.anchor(top: labelDate.bottomAnchor, left: button.leftAnchor, right: button.rightAnchor, paddingTop: 2,height: 20)
            
        }
        
        
        
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
        scView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)

        view.backgroundColor = .white
        configureNavigationBar()
        configureLayout()
    }
    
//    @objc
    @objc func btnTouch(sender: CustomTap){
        guard let tanggal = sender.ourCustomValue else {
            return
        }
        print(tanggal)
    }
    
   
    
    func configureLayout(){
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        contrainerView.anchor(top: scView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 100, paddingLeft: 16, paddingRight: 16)
        contrainerView.dropShadow(color: UIColor.blue, opacity: 1, offSet: CGSize(width: 5, height: 5), radius: 5, scale: false)
    }
    

    func configureNavigationBar(){
        navigationItem.title = "Day Off Driver"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipses.bubble.fill"), style: .plain, target: self, action: #selector(onClickChatButton))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
    }

}


class CustomTap: UITapGestureRecognizer {
    var ourCustomValue: Any?
}


extension Date {

    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year,  from: self)
        dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: self)
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }

}


extension Date {
    static func dayNameFromCustomDate(customDate: Int) -> String {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let dateNow = customDate < 10 ? "\(year)-\(month)-\(0)\(customDate)" : "\(year)-\(month)-\(customDate)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateFor = DateFormatter()
        dateFor.dateFormat = "EE"
        
        let date = dateFormatter.date(from: dateNow)
        let dayString = dateFor.string(from: date!)
        
        
        return dayString
    }
    
    static func dateStringFrom(customDate: Int) -> String {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let dateNow = customDate < 10 ? "\(year)-\(month)-\(0)\(customDate)" : "\(year)-\(month)-\(customDate)"
        
        return dateNow
    }
}
