//
//  DayOffViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import FirebaseCrashlytics

class PlanVc: UIViewController {
    
    var dayOfVm = DayOffViewModel()
    var dataDayOff: DayOffPost!
    var listShift: [Int]? = nil
    
    var week1:[String: Any] = [
        "Sunday": [45],
        "Monday": NSNull(),
        "Tuesday": NSNull(),
        "Wednesday": NSNull(),
        "Thursday": NSNull(),
        "Friday": NSNull(),
        "Saturday": NSNull(),
    ]
    
    var week2:[String: Any] = [
        "Sunday": NSNull(),
        "Monday": NSNull(),
        "Tuesday": NSNull(),
        "Wednesday": NSNull(),
        "Thursday": NSNull(),
        "Friday": NSNull(),
        "Saturday": NSNull(),
    ]
    
    var week3:[String: Any] = [
        "Sunday": NSNull(),
        "Monday": NSNull(),
        "Tuesday": NSNull(),
        "Wednesday": NSNull(),
        "Thursday": NSNull(),
        "Friday": NSNull(),
        "Saturday": NSNull(),
    ]
    
    var week4:[String: Any] = [
        "Sunday": NSNull(),
        "Monday": NSNull(),
        "Tuesday": NSNull(),
        "Wednesday": NSNull(),
        "Thursday": NSNull(),
        "Friday": NSNull(),
        "Saturday": NSNull(),
    ]
    
    var week5:[String: Any] = [
        "Sunday": NSNull(),
        "Monday": NSNull(),
        "Tuesday": NSNull(),
        "Wednesday": NSNull(),
        "Thursday": NSNull(),
        "Friday": [45],
        "Saturday": NSNull(),
    ]

    
    var dayOffPlan:[String: Any]!
    
    let months: [String] = ["January","February","Maret","April","Mei","Juni","July","Agustus","September","Oktober","November","Desember"]
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = months[Calendar.current.component(.month, from: Date())]
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var lableStatusDriver: UILabel = {
        let label = UILabel()
        label.text = "Full Time"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15,weight: .regular)
        label.textAlignment = .center
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
    
    private let saveButton: UIButton={
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular )
//        button.addTarget(self, action: #selector(setPlanClick), for: .touchUpInside)
        return button
    }()
    
    
    private let setWorkButton: UIButton={
        let button = UIButton()
        button.setTitle("Set Work Day", for: .normal)
        button.backgroundColor = UIColor(named: "grayKasumi")
        button.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular )
        button.addTarget(self, action: #selector(setWorkClick), for: .touchUpInside)
        return button
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(lableStatusDriver)
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        
        dayOffPlan = [
            "1": week1,
            "2": week2,
            "3": week3,
            "4": week4,
            "5": week5,
        ]
        
        scView = UIScrollView()
        view.addSubview(scView)
        scView.isScrollEnabled = true
        scView.alwaysBounceHorizontal = false
        scView.showsHorizontalScrollIndicator = false
        scView.anchor(top: lableStatusDriver.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10,height: 100)
        view.addSubview(contrainerView)
        contrainerView.addSubview(dateLabel)
        contrainerView.addSubview(subTitleLabel)
        contrainerView.addSubview(tableView)
        contrainerView.addSubview(dayOffLable)
        contrainerView.addSubview(saveButton)
        contrainerView.addSubview(setWorkButton)
        scView.translatesAutoresizingMaskIntoConstraints = false
        
        
        configureNavigationBar()
        configureLayout()
        setupDisplayDayOff()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let data: [String: DayOffPostDay] = [
            "1": DayOffPostDay(Sunday: NSNull(), Monday: NSNull(), Tuesday: [45,46,47,48], Wednesday: [45,46,47,48], Thursday: [45,46,47,48], Friday: [45,46,47,48], Saturday: [45,46,47,48]),
            "2": DayOffPostDay(Sunday: [45,46,47,48], Monday: NSNull(), Tuesday: [45,46,47,48], Wednesday: [45,46,47,48], Thursday: [45,46,47,48], Friday: [45,46,47,48], Saturday: NSNull()),
            "3": DayOffPostDay(Sunday: [45,46,47,48], Monday: [45,46,47,48], Tuesday: [45,46,47,48], Wednesday: [45,46,47,48], Thursday: [45,46,47,48], Friday: NSNull(), Saturday: NSNull()),
            "4": DayOffPostDay(Sunday: [45,46,47,48], Monday: [45,46,47,48], Tuesday: [45,46,47,48], Wednesday: [45,46,47,48], Thursday: NSNull(), Friday: NSNull(), Saturday: [45,46,47,48]),
            "5": DayOffPostDay(Sunday: [45,46,47,48], Monday: [45,46,47,48], Tuesday: NSNull(), Wednesday: [45,46,47,48], Thursday: [45,46,47,48], Friday: NSNull(), Saturday: [45,46,47,48]),
        ]
        
        
        dataDayOff = DayOffPost(id_driver: 19, day_off_status_plan: data)
        
//       let dataBaru = dayOfVm.decodeDataPlan(data: encode(value: dataDayOff))
        
//        dayOfVm.setPlanDayOff(data: dataDayOff)
        
        print(dayOffPlan)
        
    }
    
    
   
    func encode( value: DayOffPost) -> Data {
        return withUnsafePointer(to:value) { p in
            Data(bytes: p, count: MemoryLayout.size(ofValue:value))
        }
    }
    
    func configureLayout(){
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        lableStatusDriver.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        
        contrainerView.anchor(top: scView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        contrainerView.dropShadow(color: UIColor.blue, opacity: 1, offSet: CGSize(width: 5, height: 5), radius: 5, scale: false)
        subTitleLabel.anchor(top: contrainerView.topAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        dateLabel.anchor(top: subTitleLabel.bottomAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        tableView.anchor(top: dateLabel.bottomAnchor, left: contrainerView.leftAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 20, paddingBottom: 60, paddingLeft: 10, paddingRight: 10)
        
        saveButton.anchor(top: tableView.bottomAnchor, left: contrainerView.leftAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, width: 150, height: 40)
        
        setWorkButton.anchor(top: tableView.bottomAnchor, left: saveButton.rightAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, height: 40)
        
        dayOffLable.translatesAutoresizingMaskIntoConstraints = false
        dayOffLable.centerYAnchor.constraint(equalTo: contrainerView.centerYAnchor).isActive = true
        dayOffLable.centerXAnchor.constraint(equalTo: contrainerView.centerXAnchor).isActive = true
    }
    

    func configureNavigationBar(){
        navigationItem.title = "Plan Next Month"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func setWorkClick(){
        switch setWorkButton.title(for: .normal) {
        case "Set Work Day":
            listShift = [45,46,47,48]
        default:
            listShift = nil
        }
        
        if listShift == nil {
            tableView.isHidden = true
            dayOffLable.isHidden = false
            setWorkButton.setTitle("Set Work Day", for: .normal)
        }else{
            tableView.isHidden = false
            dayOffLable.isHidden = true
            tableView.reloadData()
            setWorkButton.setTitle("Set To DayOff", for: .normal)
        }
    }
    
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
            let dataWeek = dayOffPlan["1"] as! [String: Any]
            switch day {
            case "Sun":
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        if week2 {
            let dataWeek = dayOffPlan["2"] as! [String: Any]
            switch day {
            case "Sun":
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        if week3 {
            let dataWeek = dayOffPlan["3"] as! [String: Any]
            switch day {
            case "Sun":
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        if week4 {
            let dataWeek = dayOffPlan["4"] as! [String: Any]
            switch day {
            case "Sun":
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        
        if week5 {
            let dataWeek = dayOffPlan["5"] as! [String: Any]
            switch day {
            case "Sun":
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        
        if listShift == nil {
            tableView.isHidden = true
            dayOffLable.isHidden = false
            setWorkButton.setTitle("Set Work Day", for: .normal)
        }else{
            tableView.isHidden = false
            dayOffLable.isHidden = true
            tableView.reloadData()
            setWorkButton.setTitle("Set To DayOff", for: .normal)
        }
        
    }
}




extension PlanVc: UITableViewDelegate, UITableViewDataSource {
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



extension PlanVc {
    private func setupDisplayDayOff(){
        let montnNumber = Date.monthNumber() + 1
        let month = montnNumber <= 12 ? Date.monthNumber() + 1 : Date.monthNumber()
        let year = montnNumber <= 12 ? Date.yearNumber() : Date.yearNumber()+1
        let daysInMounth = Date().daysInMonth(month, year)
        
        for i in 1 ... daysInMounth {
            let button = UIView()
            let container = UIView()
            let labelDay = UILabel()
            let labelDesc = UILabel()
            let labelDate = UILabel()
            
            labelDay.text = Date.dayNameFromCustomDate(customDate: i, year: year, month: month)
            labelDay.textAlignment = .center
            labelDesc.textAlignment = .center
            
            labelDate.textColor = .white
            labelDate.text = "\(i < 10 ? "\(0)\(i)" : "\(i)")"
            labelDate.textAlignment = .center
           
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor(named: "grayKasumi2")
            
            let customTap = CustomTap(target: self, action: #selector(btnTouch(sender:)))
            customTap.ourCustomValue = Date.dateStringNextMonthFrom(customDate: i, year: year, month: month)
            customTap.day = Date.dayNameFromCustomDate(customDate: i, year: year, month: month)
            customTap.index = i
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
            
            
            
            
            let week1 = i <= 7
            let week2 = i > 7 && i <= 14
            let week3 = i > 14 && i <= 21
            let week4 = i > 21 && i <= 28
            let week5 = i > 28
            
            if week1 {
                if let dayName = labelDay.text {
                    let dataWeek = dayOffPlan["1"] as! [String: Any]
                    switch dayName {
                    case "Sun":
                        if dataWeek["Sunday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Sunday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Monday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Monday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Tuesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Wednesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Thursday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Thursday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Friday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Friday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Saturday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Saturday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                    let dataWeek = dayOffPlan["2"] as! [String: Any]
                    switch dayName {
                    case "Sun":
                        if dataWeek["Sunday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Sunday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Monday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Monday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Tuesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Wednesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Thursday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Thursday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Friday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Friday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Saturday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Saturday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                    let dataWeek = dayOffPlan["3"] as! [String: Any]
                    switch dayName {
                    case "Sun":
                        if dataWeek["Sunday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Sunday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Monday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Monday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Tuesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Wednesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Thursday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Thursday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Friday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Friday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Saturday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Saturday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                    let dataWeek = dayOffPlan["4"] as! [String: Any]
                    switch dayName {
                    case "Sun":
                        if dataWeek["Sunday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Sunday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Monday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Monday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Tuesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Wednesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Thursday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Thursday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Friday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Friday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Saturday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Saturday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                    let dataWeek = dayOffPlan["5"] as! [String: Any]
                    switch dayName {
                    case "Sun":
                        if dataWeek["Sunday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Sunday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Monday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Monday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Tuesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Wednesday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Thursday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Thursday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Friday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Friday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
                        if dataWeek["Saturday"] as? [Int] != nil {
                            let array:[Int]? = dataWeek["Saturday"] as? [Int]
                            labelDesc.text = "\(array?.count ?? 0) Shift"
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
            
            
            
            
//            end
        }
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
        scView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        
    }
}
