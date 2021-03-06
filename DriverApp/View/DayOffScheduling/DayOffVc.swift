//
//  DayOffViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import FirebaseCrashlytics

class DayOffVc: UIViewController {
    
    var dayOfVm = DayOffViewModel()
    var dataDayOff: DayOffStatus!
    var listShift: [Int]? = nil
    
    let months: [String] = ["January","February","Maret","April","Mei","Juni","July","Agustus","September","Oktober","November","Desember"]
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = months[Calendar.current.component(.month, from: Date())-1]
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    
    lazy var dayOffLable: UILabel = {
        let label = UILabel()
        label.text = "Day Off"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 30,weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private let planButotn: UIButton={
        let button = UIButton()
        button.setTitle("Plan Next Month", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular )
        button.addTarget(self, action: #selector(setPlanClick), for: .touchUpInside)
        return button
    }()
    
    var scView:UIScrollView!
    let buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10

    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shift on this date"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18,weight: .regular)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14,weight: .regular)
        return label
    }()
    
    let contrainerView: UIView = {
        let view=UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(ShiftCell.self, forCellReuseIdentifier: ShiftCell.id)
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    
    
    @objc
    func setPlanClick(){
        let vc = PlanVc()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(planButotn)
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        scView = UIScrollView()
        view.addSubview(scView)
        scView.isScrollEnabled = true
        scView.alwaysBounceHorizontal = false
        scView.showsHorizontalScrollIndicator = false
        scView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10,height: 100)
        view.addSubview(contrainerView)
        contrainerView.addSubview(dateLabel)
        contrainerView.addSubview(subTitleLabel)
        contrainerView.addSubview(tableView)
        contrainerView.addSubview(dayOffLable)
        scView.translatesAutoresizingMaskIntoConstraints = false
        
        
        configureNavigationBar()
        configureLayout()
        todayDate()
        
        tableView.delegate = self
        tableView.dataSource = self
        dayOfVm.getDataDayOff(idDriver: "19") { (success) in
            switch success {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    self.dataDayOff = data
                    self.setupDisplayDayOff()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func todayDate(){
        let date = Date()
        let dateFor = DateFormatter()
        dateFor.dateFormat = "EE, dd MMM Y"
        
        let dayString = dateFor.string(from: date)
        dateLabel.text = dayString
    }
    
//    @objc
    @objc func btnTouch(sender: CustomTap){
        guard let tanggal = sender.ourCustomValue, let day = sender.day, let index = sender.index else {
            return
        }
        let date = Date.dayStringFromStringDate(customDate: tanggal as! String)
        dateLabel.text = date
        
        let week1 = index <= 7
        let week2 = index > 7 && index <= 14
        let week3 = index > 14 && index <= 21
        let week4 = index > 21 && index <= 28
        let week5 = index > 28
        
        if week1 {
            switch day {
            case "Sun":
                listShift = dataDayOff.week1.Sun
            case "Mon":
                listShift = dataDayOff.week1.Mon
            case "Tue":
                listShift = dataDayOff.week1.Tue
            case "Wed":
                listShift = dataDayOff.week1.Wed
            case "Thu":
                listShift = dataDayOff.week1.Thu
            case "Fri":
                listShift = dataDayOff.week1.Fri
            default:
                listShift = dataDayOff.week1.Sat
            }
        }
        if week2 {
            switch day {
            case "Sun":
                listShift = dataDayOff.week2.Sun
            case "Mon":
                listShift = dataDayOff.week2.Mon
            case "Tue":
                listShift = dataDayOff.week2.Tue
            case "Wed":
                listShift = dataDayOff.week2.Wed
            case "Thu":
                listShift = dataDayOff.week2.Thu
            case "Fri":
                listShift = dataDayOff.week2.Fri
            default:
                listShift = dataDayOff.week2.Sat
            }
        }
        if week3 {
            switch day {
            case "Sun":
                listShift = dataDayOff.week3.Sun
            case "Mon":
                listShift = dataDayOff.week3.Mon
            case "Tue":
                listShift = dataDayOff.week3.Tue
            case "Wed":
                listShift = dataDayOff.week3.Wed
            case "Thu":
                listShift = dataDayOff.week3.Thu
            case "Fri":
                listShift = dataDayOff.week3.Fri
            default:
                listShift = dataDayOff.week3.Sat
            }
        }
        if week4 {
            switch day {
            case "Sun":
                listShift = dataDayOff.week4.Sun
            case "Mon":
                listShift = dataDayOff.week4.Mon
            case "Tue":
                listShift = dataDayOff.week4.Tue
            case "Wed":
                listShift = dataDayOff.week4.Wed
            case "Thu":
                listShift = dataDayOff.week4.Thu
            case "Fri":
                listShift = dataDayOff.week4.Fri
            default:
                listShift = dataDayOff.week4.Sat
            }
        }
        
        if week5 {
            switch day {
            case "Sun":
                listShift = dataDayOff.week5.Sun
            case "Mon":
                listShift = dataDayOff.week5.Mon
            case "Tue":
                listShift = dataDayOff.week5.Tue
            case "Wed":
                listShift = dataDayOff.week5.Wed
            case "Thu":
                listShift = dataDayOff.week5.Thu
            case "Fri":
                listShift = dataDayOff.week5.Fri
            default:
                listShift = dataDayOff.week5.Sat
            }
        }
        
        if listShift == nil {
            tableView.isHidden = true
            dayOffLable.isHidden = false
        }else{
            tableView.isHidden = false
            dayOffLable.isHidden = true
            tableView.reloadData()
        }
       
    }
    
   
    
    func configureLayout(){
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: planButotn.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        planButotn.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16,width: 200, height: 30)
        
        contrainerView.anchor(top: scView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        contrainerView.dropShadow(color: UIColor.blue, opacity: 1, offSet: CGSize(width: 5, height: 5), radius: 5, scale: false)
        subTitleLabel.anchor(top: contrainerView.topAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        dateLabel.anchor(top: subTitleLabel.bottomAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        tableView.anchor(top: dateLabel.bottomAnchor, left: contrainerView.leftAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 20, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        
        dayOffLable.translatesAutoresizingMaskIntoConstraints = false
        dayOffLable.centerYAnchor.constraint(equalTo: contrainerView.centerYAnchor).isActive = true
        dayOffLable.centerXAnchor.constraint(equalTo: contrainerView.centerXAnchor).isActive = true
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
    var day: String?
    var index: Int?
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
    
    static func dayStringFromStringDate(customDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateFor = DateFormatter()
        dateFor.dateFormat = "EE, dd MMM Y"
        
        let date = dateFormatter.date(from: customDate)
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

extension DayOffVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = listShift {
            return data.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShiftCell.id,for: indexPath) as! ShiftCell
        if let data = listShift {
            cell.valueLabel = data[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}



extension DayOffVc {
    private func setupDisplayDayOff(){
        let daysInMounth = Date().daysInMonth()
        let date = Date()
        let dateFor = DateFormatter()
        dateFor.dateFormat = "dd"
        
        let dateToday = dateFor.string(from: date)
        
        for i in 1 ... daysInMounth {
            let button = UIView()
            let container = UIView()
            let labelDay = UILabel()
            let labelDesc = UILabel()
            let labelDate = UILabel()
            let indicatorToday = UIView()
            
            labelDay.text = Date.dayNameFromCustomDate(customDate: i)
            labelDay.textAlignment = .center
            labelDesc.textAlignment = .center
            
            labelDate.textColor = .white
            labelDate.text = "\(i < 10 ? "\(0)\(i)" : "\(i)")"
            labelDate.textAlignment = .center
            
            indicatorToday.backgroundColor = .red
            indicatorToday.layer.cornerRadius = 2
           
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.darkGray
            let customTap = CustomTap(target: self, action: #selector(btnTouch(sender:)))
            customTap.ourCustomValue = Date.dateStringFrom(customDate: i)
            customTap.day = Date.dayNameFromCustomDate(customDate: i)
            customTap.index = i
            button.addGestureRecognizer(customTap)
            container.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 80, height: 80)
            
            xOffset = xOffset + CGFloat(buttonPadding) + container.frame.size.width
            scView.addSubview(container)
            container.addSubview(labelDay)
            container.addSubview(button)
            button.addSubview(labelDesc)
            button.addSubview(labelDate)
            if "\(i < 10 ? "\(0)\(i)" : "\(i)")" == "\(dateToday)" {
                container.addSubview(indicatorToday)
                indicatorToday.anchor(top: button.bottomAnchor, left: container.leftAnchor, right: container.rightAnchor, paddingTop: 5, height: 5)
            }
            labelDay.font = UIFont.systemFont(ofSize: 16,weight: .bold)
            labelDesc.text = "Day Off"
            labelDesc.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            labelDesc.textColor = .white
            
            labelDay.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor, height: 20)
            button.anchor(top: labelDay.bottomAnchor, left: container.leftAnchor,bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 5)
            labelDate.anchor(top: button.topAnchor, left: button.leftAnchor, right: button.rightAnchor, paddingTop: 6,height: 20)
            labelDesc.anchor(top: labelDate.bottomAnchor, left: button.leftAnchor, right: button.rightAnchor, paddingTop: 2,height: 20)
            
            let week1 = i <= 7
            let week2 = i > 7 && i <= 14
            let week3 = i > 14 && i <= 21
            let week4 = i > 21 && i <= 28
            let week5 = i > 28
            
            if week1 {
                if let dayName = labelDay.text {
                    switch dayName {
                    case "Sun":
                        if dataDayOff.week1.Sun != nil {
                            let array:[Int]? = dataDayOff.week1.Sun ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Mon":
                        if dataDayOff.week1.Mon != nil {
                            let array:[Int]? = dataDayOff.week1.Mon ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Tue":
                        if dataDayOff.week1.Tue != nil {
                            let array:[Int]? = dataDayOff.week1.Tue ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Wed":
                        if dataDayOff.week1.Wed != nil {
                            let array:[Int]? = dataDayOff.week1.Wed ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Thu":
                        if dataDayOff.week1.Thu != nil {
                            let array:[Int]? = dataDayOff.week1.Thu ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Fri":
                        if dataDayOff.week1.Fri != nil {
                            let array:[Int]? = dataDayOff.week1.Fri ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    default:
                        if dataDayOff.week1.Sat != nil {
                            let array:[Int]? = dataDayOff.week1.Sat ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    }
                }
            }
            
            if week2 {
                if let dayName = labelDay.text {
                    switch dayName {
                    case "Sun":
                        if dataDayOff.week2.Sun != nil {
                            let array:[Int]? = dataDayOff.week2.Sun ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Mon":
                        if dataDayOff.week2.Mon != nil {
                            let array:[Int]? = dataDayOff.week2.Mon ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Tue":
                        if dataDayOff.week2.Tue != nil {
                            let array:[Int]? = dataDayOff.week2.Tue ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Wed":
                        if dataDayOff.week2.Wed != nil {
                            let array:[Int]? = dataDayOff.week2.Wed ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Thu":
                        if dataDayOff.week2.Thu != nil {
                            let array:[Int]? = dataDayOff.week2.Thu ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Sat":
                        if dataDayOff.week2.Sat != nil {
                            let array:[Int]? = dataDayOff.week2.Sat ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    default:
                        if dataDayOff.week2.Fri != nil {
                            let array:[Int]? = dataDayOff.week2.Fri ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    }
                }
            }
            
            if week3 {
                if let dayName = labelDay.text {
                    switch dayName {
                    case "Sun":
                        if dataDayOff.week3.Sun != nil {
                            let array:[Int]? = dataDayOff.week3.Sun ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Mon":
                        if dataDayOff.week3.Mon != nil {
                            let array:[Int]? = dataDayOff.week3.Mon ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Tue":
                        if dataDayOff.week3.Tue != nil {
                            let array:[Int]? = dataDayOff.week3.Tue ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Wed":
                        if dataDayOff.week3.Wed != nil {
                            let array:[Int]? = dataDayOff.week3.Wed ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Thu":
                        if dataDayOff.week3.Thu != nil {
                            let array:[Int]? = dataDayOff.week3.Thu ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Sat":
                        if dataDayOff.week3.Sat != nil {
                            let array:[Int]? = dataDayOff.week3.Sat ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    default:
                        if dataDayOff.week3.Fri != nil {
                            let array:[Int]? = dataDayOff.week3.Fri ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    }
                }
            }
            
            if week4 {
                if let dayName = labelDay.text {
                    switch dayName {
                    case "Sun":
                        if dataDayOff.week4.Sun != nil {
                            let array:[Int]? = dataDayOff.week4.Sun ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Mon":
                        if dataDayOff.week4.Mon != nil {
                            let array:[Int]? = dataDayOff.week4.Mon ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Tue":
                        if dataDayOff.week4.Tue != nil {
                            let array:[Int]? = dataDayOff.week4.Tue ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Wed":
                        if dataDayOff.week4.Wed != nil {
                            let array:[Int]? = dataDayOff.week4.Wed ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Thu":
                        if dataDayOff.week4.Thu != nil {
                            let array:[Int]? = dataDayOff.week4.Thu ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Sat":
                        if dataDayOff.week4.Sat != nil {
                            let array:[Int]? = dataDayOff.week4.Sat ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    default:
                        if dataDayOff.week4.Fri != nil {
                            let array:[Int]? = dataDayOff.week4.Fri ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    }
                }
            }
            
            if week5 {
                if let dayName = labelDay.text {
                    switch dayName {
                    case "Sun":
                        if dataDayOff.week5.Sun != nil {
                            let array:[Int]? = dataDayOff.week5.Sun ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Mon":
                        if dataDayOff.week5.Mon != nil {
                            let array:[Int]? = dataDayOff.week5.Mon ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Tue":
                        if dataDayOff.week5.Tue != nil {
                            let array:[Int]? = dataDayOff.week5.Tue ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Wed":
                        if dataDayOff.week5.Wed != nil {
                            let array:[Int]? = dataDayOff.week5.Wed ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Thu":
                        if dataDayOff.week5.Thu != nil {
                            let array:[Int]? = dataDayOff.week5.Thu ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    case "Sat":
                        if dataDayOff.week5.Sat != nil {
                            let array:[Int]? = dataDayOff.week5.Sat ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    default:
                        if dataDayOff.week5.Fri != nil {
                            let array:[Int]? = dataDayOff.week5.Fri ?? nil
                            labelDesc.text = "\(array!.count) Shift"
                            button.backgroundColor = UIColor(named: "yellowKasumi")
                            labelDate.textColor = .black
                            labelDesc.textColor = .black
                        }else {
                            labelDesc.text = "Day Off"
                            button.backgroundColor = UIColor(named: "grayKasumi2")
                            labelDate.textColor = .white
                            labelDesc.textColor = .white
                        }
                    }
                }
            }
        }
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
        scView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        
        
        let intDate:Int? = Int(dateToday)
        scView.setContentOffset(CGPoint(x: 80*intDate!-30, y: 0), animated: true)
    }
}
