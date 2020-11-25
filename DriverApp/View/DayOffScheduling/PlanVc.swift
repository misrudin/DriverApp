//
//  DayOffViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import FirebaseCrashlytics
import JGProgressHUD

@available(iOS 13.0, *)
class PlanVc: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    private let emptyImage: UIView = {
        let view = UIView()
        let imageView: UIImageView = {
           let img = UIImageView()
            img.image = UIImage(named: "emptyImage")
            img.tintColor = UIColor(named: "orangeKasumi")
            img.clipsToBounds = true
            img.layer.masksToBounds = true
            img.translatesAutoresizingMaskIntoConstraints = false
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.backgroundColor = UIColor(named: "bgKasumi")
        view.layer.cornerRadius = 120/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    var dayOfVm = DayOffViewModel()
    var dataDayOff: DayOffPost!
    var listShift: [Int]? = nil
    var dayOffPlanData: DayOfParent? = nil
    
    let slideVC = SelectShift()
    
    var shiftTimeVm = ShiftTimeViewModel()
    
    var shiftTime = [ShiftTime]()
    
    var selectedWeek: String?
    var selectedDay: String?
    
    var week1:[String: Any] = [
        "Sunday": NSNull(),
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
        "Friday": NSNull(),
        "Saturday": NSNull(),
    ]
    
    var montnNumber = Date.monthNumber() + 1
    
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
        button.addTarget(self, action: #selector(onSaveClick), for: .touchUpInside)
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
        button.isHidden = false
        return button
    }()
    
    private let editButton: UIButton={
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = UIColor(named: "grayKasumi")
        button.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular )
        button.addTarget(self, action: #selector(openModal), for: .touchUpInside)
        button.isHidden = true
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
    
    //MARK:- Colection view
    
    private let colectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PlanCell.self, forCellWithReuseIdentifier: PlanCell.id)
        cv.backgroundColor = UIColor(named: "bgKasumi")
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    //MARK:- view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(lableStatusDriver)
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        view.addSubview(colectionView)
        colectionView.delegate = self
        colectionView.dataSource = self
        
        view.addSubview(contrainerView)
        contrainerView.addSubview(dateLabel)
        contrainerView.addSubview(subTitleLabel)
        contrainerView.addSubview(tableView)
        contrainerView.addSubview(emptyImage)
        contrainerView.addSubview(saveButton)
        contrainerView.addSubview(setWorkButton)
        contrainerView.addSubview(editButton)
        
        
        configureNavigationBar()
        configureLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        getDataDayOffPlan()
        getListShiftTime()
        
        slideVC.delegate = self
    }
    
    
    private func getListShiftTime(){
        spiner.show(in: view)
        shiftTimeVm.getAllShiftTime { (res) in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    self.shiftTime = data
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.spiner.dismiss()
            }
        }
    }
    
    
    
    //MARK: - Shadow
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyImage.dropShadow(color: UIColor(named: "orangeKasumi")!, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 120/2, scale: true)
        contrainerView.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    
    //MARK: - Show modal
    @objc
    func openModal(){
        var dataShifts:[CustomList] = []
        
        for item in shiftTime {
            if let dataList = listShift {
                for d in dataList {
                    print(d)
                }
            }
            
            let data: CustomList = CustomList(id: item.id_shift_time, name: item.label_data, selected: false)
            dataShifts.append(data)
        }
        
        slideVC.shifts = dataShifts
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    
        //MARK:- Get day off plan
    func getDataDayOffPlan(){
        
        guard let data = dayOffPlanData else {return}
        
        switch data.workingStatus {
        case "full time":
            self.lableStatusDriver.text = "Full Time"
            editButton.isHidden = true
            setWorkButton.isHidden = false
        case "part time":
            self.lableStatusDriver.text = "Part Time"
            editButton.isHidden = false
            setWorkButton.isHidden = true
        case "freelance":
            self.lableStatusDriver.text = "Freelance"
            editButton.isHidden = false
            setWorkButton.isHidden = true
        default:
            self.lableStatusDriver.text = data.workingStatus
            editButton.isHidden = true
            setWorkButton.isHidden = false
        }
        
        if data.dayOfStatusPlan == nil {
            self.dayOffPlan = [
                "1": self.week1,
                "2": self.week2,
                "3": self.week3,
                "4": self.week4,
                "5": self.week5,
            ]
        }else {
            var week1: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week2: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week3: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week4: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week5: [String: Any] = NSMutableDictionary() as! [String : Any]
            let dataWeek1 = data.dayOfStatusPlan?.week1
            let dataWeek2 = data.dayOfStatusPlan?.week2
            let dataWeek3 = data.dayOfStatusPlan?.week3
            let dataWeek4 = data.dayOfStatusPlan?.week4
            let dataWeek5 = data.dayOfStatusPlan?.week5
            week1["Sunday"] = dataWeek1?.Sun == nil || dataWeek1?.Sun?.count == 0 ? NSNull() : dataWeek1?.Sun
            week1["Monday"] = dataWeek1?.Mon == nil || dataWeek1?.Sun?.count == 0 ? NSNull() : dataWeek1?.Mon
            week1["Tuesday"] = dataWeek1?.Tue == nil || dataWeek1?.Tue?.count == 0 ? NSNull() : dataWeek1?.Tue
            week1["Wednesday"] = dataWeek1?.Wed == nil || dataWeek1?.Wed?.count == 0 ? NSNull() : dataWeek1?.Wed
            week1["Thursday"] = dataWeek1?.Thu == nil || dataWeek1?.Thu?.count == 0 ? NSNull() : dataWeek1?.Thu
            week1["Friday"] = dataWeek1?.Fri == nil || dataWeek1?.Fri?.count == 0 ? NSNull() : dataWeek1?.Fri
            week1["Saturday"] = dataWeek1?.Sat == nil || dataWeek1?.Sat?.count == 0 ? NSNull() : dataWeek1?.Sat
            
            week2["Sunday"] = dataWeek2?.Sun == nil || dataWeek2?.Sun?.count == 0 ? NSNull() : dataWeek2?.Sun
            week2["Monday"] = dataWeek2?.Mon == nil || dataWeek2?.Sun?.count == 0 ? NSNull() : dataWeek2?.Mon
            week2["Tuesday"] = dataWeek2?.Tue == nil || dataWeek2?.Tue?.count == 0 ? NSNull() : dataWeek2?.Tue
            week2["Wednesday"] = dataWeek2?.Wed == nil || dataWeek2?.Wed?.count == 0 ? NSNull() : dataWeek2?.Wed
            week2["Thursday"] = dataWeek2?.Thu == nil || dataWeek2?.Thu?.count == 0 ? NSNull() : dataWeek2?.Thu
            week2["Friday"] = dataWeek2?.Fri == nil || dataWeek2?.Fri?.count == 0 ? NSNull() : dataWeek2?.Fri
            week2["Saturday"] = dataWeek2?.Sat == nil || dataWeek2?.Sat?.count == 0 ? NSNull() : dataWeek2?.Sat
            
            week3["Sunday"] = dataWeek3?.Sun == nil || dataWeek3?.Sun?.count == 0 ? NSNull() : dataWeek3?.Sun
            week3["Monday"] = dataWeek3?.Mon == nil || dataWeek3?.Sun?.count == 0 ? NSNull() : dataWeek3?.Mon
            week3["Tuesday"] = dataWeek3?.Tue == nil || dataWeek3?.Tue?.count == 0 ? NSNull() : dataWeek3?.Tue
            week3["Wednesday"] = dataWeek3?.Wed == nil || dataWeek3?.Wed?.count == 0 ? NSNull() : dataWeek3?.Wed
            week3["Thursday"] = dataWeek3?.Thu == nil || dataWeek3?.Thu?.count == 0 ? NSNull() : dataWeek3?.Thu
            week3["Friday"] = dataWeek3?.Fri == nil || dataWeek3?.Fri?.count == 0 ? NSNull() : dataWeek3?.Fri
            week3["Saturday"] = dataWeek3?.Sat == nil || dataWeek3?.Sat?.count == 0 ? NSNull() : dataWeek3?.Sat
            
            week4["Sunday"] = dataWeek4?.Sun == nil || dataWeek4?.Sun?.count == 0 ? NSNull() : dataWeek4?.Sun
            week4["Monday"] = dataWeek4?.Mon == nil || dataWeek4?.Sun?.count == 0 ? NSNull() : dataWeek4?.Mon
            week4["Tuesday"] = dataWeek4?.Tue == nil || dataWeek4?.Tue?.count == 0 ? NSNull() : dataWeek4?.Tue
            week4["Wednesday"] = dataWeek4?.Wed == nil || dataWeek4?.Wed?.count == 0 ? NSNull() : dataWeek4?.Wed
            week4["Thursday"] = dataWeek4?.Thu == nil || dataWeek4?.Thu?.count == 0 ? NSNull() : dataWeek4?.Thu
            week4["Friday"] = dataWeek4?.Fri == nil || dataWeek4?.Fri?.count == 0 ? NSNull() : dataWeek4?.Fri
            week4["Saturday"] = dataWeek4?.Sat == nil || dataWeek4?.Sat?.count == 0 ? NSNull() : dataWeek4?.Sat
            
            week5["Sunday"] = dataWeek5?.Sun == nil || dataWeek5?.Sun?.count == 0 ? NSNull() : dataWeek5?.Sun
            week5["Monday"] = dataWeek5?.Mon == nil || dataWeek5?.Sun?.count == 0 ? NSNull() : dataWeek5?.Mon
            week5["Tuesday"] = dataWeek5?.Tue == nil || dataWeek5?.Tue?.count == 0 ? NSNull() : dataWeek5?.Tue
            week5["Wednesday"] = dataWeek5?.Wed == nil || dataWeek5?.Wed?.count == 0 ? NSNull() : dataWeek5?.Wed
            week5["Thursday"] = dataWeek5?.Thu == nil || dataWeek5?.Thu?.count == 0 ? NSNull() : dataWeek5?.Thu
            week5["Friday"] = dataWeek5?.Fri == nil || dataWeek5?.Fri?.count == 0 ? NSNull() : dataWeek5?.Fri
            week5["Saturday"] = dataWeek5?.Sat == nil || dataWeek5?.Sat?.count == 0 ? NSNull() : dataWeek5?.Sat
            
            self.dayOffPlan = [
                "1": week1,
                "2": week2,
                "3": week3,
                "4": week4,
                "5": week5,
            ]
        }
    }
    
    func configureLayout(){
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        lableStatusDriver.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        
        colectionView.anchor(top: lableStatusDriver.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 100)
        
        contrainerView.anchor(top: colectionView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        contrainerView.dropShadow(color: UIColor.blue, opacity: 1, offSet: CGSize(width: 5, height: 5), radius: 5, scale: false)
        subTitleLabel.anchor(top: contrainerView.topAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        dateLabel.anchor(top: subTitleLabel.bottomAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        tableView.anchor(top: dateLabel.bottomAnchor, left: contrainerView.leftAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 20, paddingBottom: 60, paddingLeft: 10, paddingRight: 10)
        
        saveButton.anchor(top: tableView.bottomAnchor, left: contrainerView.leftAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, width: 150, height: 40)
        
        setWorkButton.anchor(top: tableView.bottomAnchor, left: saveButton.rightAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, height: 40)
        
        editButton.anchor(top: tableView.bottomAnchor, left: saveButton.rightAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, height: 40)
        
        emptyImage.centerYAnchor.constraint(equalTo: contrainerView.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: contrainerView.centerXAnchor).isActive = true
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
    
    //MARK: - On Save Click
    @objc
    func onSaveClick(){
        switch lableStatusDriver.text {
        case "Full Time":
            fullTimePlan()
        case "Part Time":
            partTimePlan()
        case "Freelance":
            partTimePlan()
        default:
            print("Entah apa")
        }
    }
    
    //MARK: - Part time function
    private func partTimePlan(){
        //cek week 1 minimal 1 work
        let dataWeek1 = dayOffPlan["1"] as! [String: Any]
        
        let newData:[String: [Int]?] = [
            "Sunday": dataWeek1["Sunday"] as? [Int],
            "Monday": dataWeek1["Monday"] as? [Int],
            "Tuesday": dataWeek1["Tuesday"] as? [Int],
            "Wednesday": dataWeek1["Wednesday"] as? [Int],
            "Thursday": dataWeek1["Thursday"] as? [Int],
            "Friday": dataWeek1["Friday"] as? [Int],
            "Saturday": dataWeek1["Saturday"] as? [Int],
        ]

        let filtered = newData.filter { $0.value != nil }
        
        var week1Count = 0
        
        if let sunday = filtered["Sunday"] {
            if let sun = sunday?.count {
                week1Count += sun
            }
        }
        
        if let monday = filtered["Monday"] {
            if let mon = monday?.count {
                week1Count += mon
            }
        }
        
        if let tuesday = filtered["Tuesday"] {
            if let tue = tuesday?.count {
                week1Count += tue
            }
        }
        
        if let wednesday = filtered["Wednesday"] {
            if let wed = wednesday?.count {
                week1Count += wed
            }
        }
        
        if let thursday = filtered["Thursday"] {
            if let thu = thursday?.count {
                week1Count += thu
            }
        }
        
        if let friday = filtered["Friday"] {
            if let fri = friday?.count {
                week1Count += fri
            }
        }
        
        if let saturday = filtered["Saturday"] {
            if let sat = saturday?.count {
                week1Count += sat
            }
        }
        
        
        if week1Count < 1 {
            showAlert(text: "Minimal select 1 shift to work in week 1 !")
            return
        }
 
        //cek week 2 minimal 1 work
        let dataWeek2 = dayOffPlan["2"] as! [String: Any]
        
        let newData2:[String: [Int]?] = [
            "Sunday": dataWeek2["Sunday"] as? [Int],
            "Monday": dataWeek2["Monday"] as? [Int],
            "Tuesday": dataWeek2["Tuesday"] as? [Int],
            "Wednesday": dataWeek2["Wednesday"] as? [Int],
            "Thursday": dataWeek2["Thursday"] as? [Int],
            "Friday": dataWeek2["Friday"] as? [Int],
            "Saturday": dataWeek2["Saturday"] as? [Int],
        ]

        let filtered2 = newData2.filter { $0.value != nil }
        var week2Count = 0
        
        if let sunday = filtered2["Sunday"] {
            if let sun = sunday?.count {
                week2Count += sun
            }
        }
        
        if let monday = filtered2["Monday"] {
            if let mon = monday?.count {
                week2Count += mon
            }
        }
        
        if let tuesday = filtered2["Tuesday"] {
            if let tue = tuesday?.count {
                week2Count += tue
            }
        }
        
        if let wednesday = filtered2["Wednesday"] {
            if let wed = wednesday?.count {
                week2Count += wed
            }
        }
        
        if let thursday = filtered2["Thursday"] {
            if let thu = thursday?.count {
                week2Count += thu
            }
        }
        
        if let friday = filtered2["Friday"] {
            if let fri = friday?.count {
                week2Count += fri
            }
        }
        
        if let saturday = filtered2["Saturday"] {
            if let sat = saturday?.count {
                week2Count += sat
            }
        }
        if week2Count < 1 {
            showAlert(text: "Minimal select 1 shift to work in week 2 !")
            return
        }
        
        //cek week minimal 1 work
        let dataWeek3 = dayOffPlan["3"] as! [String: Any]
        
        let newData3:[String: [Int]?] = [
            "Sunday": dataWeek3["Sunday"] as? [Int],
            "Monday": dataWeek3["Monday"] as? [Int],
            "Tuesday": dataWeek3["Tuesday"] as? [Int],
            "Wednesday": dataWeek3["Wednesday"] as? [Int],
            "Thursday": dataWeek3["Thursday"] as? [Int],
            "Friday": dataWeek3["Friday"] as? [Int],
            "Saturday": dataWeek3["Saturday"] as? [Int],
        ]

        let filtered3 = newData3.filter { $0.value != nil }
        var week3Count = 0
        
        if let sunday = filtered3["Sunday"] {
            if let sun = sunday?.count {
                week3Count += sun
            }
        }
        
        if let monday = filtered3["Monday"] {
            if let mon = monday?.count {
                week3Count += mon
            }
        }
        
        if let tuesday = filtered3["Tuesday"] {
            if let tue = tuesday?.count {
                week3Count += tue
            }
        }
        
        if let wednesday = filtered3["Wednesday"] {
            if let wed = wednesday?.count {
                week3Count += wed
            }
        }
        
        if let thursday = filtered3["Thursday"] {
            if let thu = thursday?.count {
                week3Count += thu
            }
        }
        
        if let friday = filtered3["Friday"] {
            if let fri = friday?.count {
                week3Count += fri
            }
        }
        
        if let saturday = filtered3["Saturday"] {
            if let sat = saturday?.count {
                week3Count += sat
            }
        }
        if week3Count < 1 {
            showAlert(text: "Minimal select 1 shift to work in week 3 !")
            return
        }
        //cek week minimal 1 work
        let dataWeek4 = dayOffPlan["4"] as! [String: Any]
        
        let newData4:[String: [Int]?] = [
            "Sunday": dataWeek4["Sunday"] as? [Int],
            "Monday": dataWeek4["Monday"] as? [Int],
            "Tuesday": dataWeek4["Tuesday"] as? [Int],
            "Wednesday": dataWeek4["Wednesday"] as? [Int],
            "Thursday": dataWeek4["Thursday"] as? [Int],
            "Friday": dataWeek4["Friday"] as? [Int],
            "Saturday": dataWeek4["Saturday"] as? [Int],
        ]

        let filtered4 = newData4.filter { $0.value != nil }
        var week4Count = 0
        
        if let sunday = filtered4["Sunday"] {
            if let sun = sunday?.count {
                week4Count += sun
            }
        }
        
        if let monday = filtered4["Monday"] {
            if let mon = monday?.count {
                week4Count += mon
            }
        }
        
        if let tuesday = filtered4["Tuesday"] {
            if let tue = tuesday?.count {
                week4Count += tue
            }
        }
        
        if let wednesday = filtered4["Wednesday"] {
            if let wed = wednesday?.count {
                week4Count += wed
            }
        }
        
        if let thursday = filtered4["Thursday"] {
            if let thu = thursday?.count {
                week4Count += thu
            }
        }
        
        if let friday = filtered4["Friday"] {
            if let fri = friday?.count {
                week4Count += fri
            }
        }
        
        if let saturday = filtered4["Saturday"] {
            if let sat = saturday?.count {
                week4Count += sat
            }
        }
        if week4Count < 1 {
            showAlert(text: "Minimal select 1 day to work in week 4 !")
            return
        }
        //cek week 5 cek ada berapa hari dulu
        
        print("week 4 \(week4Count) week 3 \(week3Count) week 2 \(week2Count) week 1 \(week1Count)")
     
//       MARK: - SIMPAN DATA
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        spiner.show(in: view)
        
        dayOfVm.setPlanDayOff(data: dayOffPlan, codeDriver: codeDriver) { (response) in
            switch response {
            case .success(_):
                self.spiner.dismiss()
                print("ok")
            case .failure(let err):
                self.spiner.dismiss()
                print(err)
            }
        }
    }
    
    
    //MARK: - Full time function
    private func fullTimePlan(){
        //cek week 1 libur min max 2 // harus 20 shift
        let dataWeek1 = dayOffPlan["1"] as! [String: Any]
        
        let newData:[String: [Int]?] = [
            "Sunday": dataWeek1["Sunday"] as? [Int],
            "Monday": dataWeek1["Monday"] as? [Int],
            "Tuesday": dataWeek1["Tuesday"] as? [Int],
            "Wednesday": dataWeek1["Wednesday"] as? [Int],
            "Thursday": dataWeek1["Thursday"] as? [Int],
            "Friday": dataWeek1["Friday"] as? [Int],
            "Saturday": dataWeek1["Saturday"] as? [Int],
        ]

        let filtered = newData.filter { $0.value != nil }
        if filtered.count != 5 {
            showAlert(text: "Select 2 day off in week 1")
            return
        }
 
        //cek week 2 libur min max 2
        let dataWeek2 = dayOffPlan["2"] as! [String: Any]
        
        let newData2:[String: [Int]?] = [
            "Sunday": dataWeek2["Sunday"] as? [Int],
            "Monday": dataWeek2["Monday"] as? [Int],
            "Tuesday": dataWeek2["Tuesday"] as? [Int],
            "Wednesday": dataWeek2["Wednesday"] as? [Int],
            "Thursday": dataWeek2["Thursday"] as? [Int],
            "Friday": dataWeek2["Friday"] as? [Int],
            "Saturday": dataWeek2["Saturday"] as? [Int],
        ]

        let filtered2 = newData2.filter { $0.value != nil }
        if filtered2.count != 5 {
            showAlert(text: "Select 2 day off in week 2")
            return
        }
        
        //cek week 3 libur min max 2
        let dataWeek3 = dayOffPlan["3"] as! [String: Any]
        
        let newData3:[String: [Int]?] = [
            "Sunday": dataWeek3["Sunday"] as? [Int],
            "Monday": dataWeek3["Monday"] as? [Int],
            "Tuesday": dataWeek3["Tuesday"] as? [Int],
            "Wednesday": dataWeek3["Wednesday"] as? [Int],
            "Thursday": dataWeek3["Thursday"] as? [Int],
            "Friday": dataWeek3["Friday"] as? [Int],
            "Saturday": dataWeek3["Saturday"] as? [Int],
        ]

        let filtered3 = newData3.filter { $0.value != nil }
        if filtered3.count != 5 {
            showAlert(text: "Select 2 day off in week 3")
            return
        }
        //cek week 4 libur min max 2
        let dataWeek4 = dayOffPlan["4"] as! [String: Any]
        
        let newData4:[String: [Int]?] = [
            "Sunday": dataWeek4["Sunday"] as? [Int],
            "Monday": dataWeek4["Monday"] as? [Int],
            "Tuesday": dataWeek4["Tuesday"] as? [Int],
            "Wednesday": dataWeek4["Wednesday"] as? [Int],
            "Thursday": dataWeek4["Thursday"] as? [Int],
            "Friday": dataWeek4["Friday"] as? [Int],
            "Saturday": dataWeek4["Saturday"] as? [Int],
        ]

        let filtered4 = newData4.filter { $0.value != nil }
        if filtered4.count != 5 {
            showAlert(text: "Select 2 day off in week 4")
            return
        }
        //cek week 5 cek ada berapa hari dulu
     
//       MARK - SIMPAN DATA
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        spiner.show(in: view)
        
        dayOfVm.setPlanDayOff(data: dayOffPlan, codeDriver: codeDriver) { (response) in
            switch response {
            case .success(_):
                self.spiner.dismiss()
                print("ok")
            case .failure(let err):
                self.spiner.dismiss()
                print(err)
            }
        }
    }
    
    func showAlert(text: String) {
        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
        Helpers().showAlert(view: self, message: text,customTitle: "Warning !", customAction1: action)
    }
    
    
//    MARK: - Set button
    @objc func setWorkClick(){
        guard let selectedWeek = selectedWeek, let selectedDay = selectedDay else {
            return
        }
        switch setWorkButton.title(for: .normal) {
        case "Set Work Day":
            listShift = [1,2,3,4]
            let newData:[String: Any] = dayOffPlan
            var dataSelected = newData["\(selectedWeek)"] as! [String: Any]
            dataSelected["\(selectedDay)"] = [1,2,3,4]
            dayOffPlan["\(selectedWeek)"] = dataSelected
        default:
            listShift = nil
            let newData:[String: Any] = dayOffPlan
            var dataSelected = newData["\(selectedWeek)"] as! [String: Any]
            dataSelected["\(selectedDay)"] = NSNull()
            dayOffPlan["\(selectedWeek)"] = dataSelected
        }
        
        if listShift == nil {
            tableView.isHidden = true
            emptyImage.isHidden = false
            setWorkButton.setTitle("Set Work Day", for: .normal)
        }else{
            tableView.isHidden = false
            emptyImage.isHidden = true
            tableView.reloadData()
            setWorkButton.setTitle("Set To DayOff", for: .normal)
        }
        
        colectionView.reloadData()
        
    }
    
    //MARK: - On select day in list
   private func btnTouch(tanggal: String, day: String, index: Int){
        let date = Date.dayStringFromStringDate(customDate: tanggal)
        dateLabel.text = date
        
        let week1 = index <= 7
        let week2 = index > 7 && index <= 14
        let week3 = index > 14 && index <= 21
        let week4 = index > 21 && index <= 28
        let week5 = index > 28
        
        if week1 {
            let dataWeek = dayOffPlan["1"] as! [String: Any]
            selectedWeek = "1"
            switch day {
            case "Sun":
                selectedDay = "Sunday"
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                selectedDay = "Monday"
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                selectedDay = "Tuesday"
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                selectedDay = "Wednesday"
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                selectedDay = "Thursday"
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                selectedDay = "Friday"
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                selectedDay = "Saturday"
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        if week2 {
            selectedWeek = "2"
            let dataWeek = dayOffPlan["2"] as! [String: Any]
            switch day {
            case "Sun":
                selectedDay = "Sunday"
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                selectedDay = "Monday"
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                selectedDay = "Tuesday"
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                selectedDay = "Wednesday"
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                selectedDay = "Thursday"
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                selectedDay = "Friday"
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                selectedDay = "Saturday"
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        if week3 {
            selectedWeek = "3"
            let dataWeek = dayOffPlan["3"] as! [String: Any]
            switch day {
            case "Sun":
                selectedDay = "Sunday"
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                selectedDay = "Monday"
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                selectedDay = "Tuesday"
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                selectedDay = "Wednesday"
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                selectedDay = "Thursday"
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                selectedDay = "Friday"
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                selectedDay = "Saturday"
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        if week4 {
            selectedWeek = "4"
            let dataWeek = dayOffPlan["4"] as! [String: Any]
            switch day {
            case "Sun":
                selectedDay = "Sunday"
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                selectedDay = "Monday"
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                selectedDay = "Tuesday"
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                selectedDay = "Wednesday"
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                selectedDay = "Thursday"
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                selectedDay = "Friday"
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                selectedDay = "Saturday"
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        
        if week5 {
            selectedWeek = "5"
            let dataWeek = dayOffPlan["5"] as! [String: Any]
            switch day {
            case "Sun":
                selectedDay = "Sunday"
                listShift = dataWeek["Sunday"] as? [Int] ?? nil
            case "Mon":
                selectedDay = "Monday"
                listShift = dataWeek["Monday"] as? [Int] ?? nil
            case "Tue":
                selectedDay = "Tuesday"
                listShift = dataWeek["Tuesday"] as? [Int] ?? nil
            case "Wed":
                selectedDay = "Wednesday"
                listShift = dataWeek["Wednesday"] as? [Int] ?? nil
            case "Thu":
                selectedDay = "Thursday"
                listShift = dataWeek["Thursday"] as? [Int] ?? nil
            case "Fri":
                selectedDay = "Friday"
                listShift = dataWeek["Friday"] as? [Int] ?? nil
            default:
                selectedDay = "Saturday"
                listShift = dataWeek["Saturday"] as? [Int] ?? nil
            }
        }
        
        if listShift == nil {
            tableView.isHidden = true
            emptyImage.isHidden = false
            setWorkButton.setTitle("Set Work Day", for: .normal)
        }else{
            tableView.isHidden = false
            emptyImage.isHidden = true
            tableView.reloadData()
            setWorkButton.setTitle("Set To DayOff", for: .normal)
        }
        
    }
}




@available(iOS 13.0, *)
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



//MARK:- colection view
@available(iOS 13.0, *)
extension PlanVc: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let month = montnNumber <= 12 ? Date.monthNumber() + 1 : Date.monthNumber()
        let year = montnNumber <= 12 ? Date.yearNumber() : Date.yearNumber()+1
        let daysInMounth = Date().daysInMonth(month, year)
        return daysInMounth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanCell.id, for: indexPath) as! PlanCell
        let month = montnNumber <= 12 ? Date.monthNumber() + 1 : Date.monthNumber()
        let year = montnNumber <= 12 ? Date.yearNumber() : Date.yearNumber()+1
        let i = indexPath.row + 1
        let dayName = Date.dayNameFromCustomDate(customDate: i, year: year, month: month)
        let dateLable = "\(i < 10 ? "\(0)\(i)" : "\(i)")"
        
        cell.dayLable.text = dayName
        cell.dateLable.text = dateLable
        
        //jumlah shift dan hari apa ini?
        let week1 = i <= 7
        let week2 = i > 7 && i <= 14
        let week3 = i > 14 && i <= 21
        let week4 = i > 21 && i <= 28
        let week5 = i > 28
        
        let color1: UIColor = .black
        let color2: UIColor = .black
        
        let bgColor1: UIColor = UIColor(named: "colorGray")!
        let bgColor2: UIColor = UIColor(named: "colorYellow")!
        
        //MARK: - Week 1
        if week1 {
            let dataWeek = dayOffPlan["1"] as! [String: Any]
            switch dayName {
            case "Sun":
                if dataWeek["Sunday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataWeek["Monday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Monday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataWeek["Tuesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataWeek["Wednesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataWeek["Thursday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataWeek["Friday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Friday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataWeek["Saturday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        
        //MARK: - Week 2
        if week2 {
            let dataWeek = dayOffPlan["2"] as! [String: Any]
            switch dayName {
            case "Sun":
                if dataWeek["Sunday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataWeek["Monday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Monday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataWeek["Tuesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataWeek["Wednesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataWeek["Thursday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataWeek["Friday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Friday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataWeek["Saturday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 3
        if week3 {
            let dataWeek = dayOffPlan["3"] as! [String: Any]
            switch dayName {
            case "Sun":
                if dataWeek["Sunday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataWeek["Monday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Monday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataWeek["Tuesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataWeek["Wednesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataWeek["Thursday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataWeek["Friday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Friday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataWeek["Saturday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 4
        if week4 {
            let dataWeek = dayOffPlan["4"] as! [String: Any]
            switch dayName {
            case "Sun":
                if dataWeek["Sunday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataWeek["Monday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Monday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataWeek["Tuesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataWeek["Wednesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataWeek["Thursday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataWeek["Friday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Friday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataWeek["Saturday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 5
        if week5 {
            let dataWeek = dayOffPlan["5"] as! [String: Any]
            switch dayName {
            case "Sun":
                if dataWeek["Sunday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataWeek["Monday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Monday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataWeek["Tuesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataWeek["Wednesday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataWeek["Thursday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataWeek["Friday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Friday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataWeek["Saturday"] as? [Int] != nil {
                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off"
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = indexPath.row + 1
        let month = montnNumber <= 12 ? Date.monthNumber() + 1 : Date.monthNumber()
        let year = montnNumber <= 12 ? Date.yearNumber() : Date.yearNumber()+1
        
        let date = Date.dateStringNextMonthFrom(customDate: i, year: year, month: month)
        let dayName = Date.dayNameFromCustomDate(customDate: i, year: year, month: month)

        btnTouch(tanggal: date, day: dayName, index: i)
    }
}

@available(iOS 13.0, *)
extension PlanVc: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

@available(iOS 13.0, *)
extension PlanVc: SelectShiftDelegate {
    func onSelectShift(_ vm: SelectShift, idShift: [Int]) {
        guard let selectedWeek = selectedWeek, let selectedDay = selectedDay else {
            return
        }
        listShift = idShift
        let newData:[String: Any] = dayOffPlan
        var dataSelected = newData["\(selectedWeek)"] as! [String: Any]
        dataSelected["\(selectedDay)"] = idShift
        dayOffPlan["\(selectedWeek)"] = dataSelected
        
        if listShift == nil {
            tableView.isHidden = true
            emptyImage.isHidden = false
            setWorkButton.setTitle("Set Work Day", for: .normal)
        }else{
            tableView.isHidden = false
            emptyImage.isHidden = true
            tableView.reloadData()
            setWorkButton.setTitle("Set To DayOff", for: .normal)
        }
        
        colectionView.reloadData()
    }
    
    func onDayOff(_ vm: SelectShift) {
        guard let selectedWeek = selectedWeek, let selectedDay = selectedDay else {
            return
        }
        listShift = nil
        let newData:[String: Any] = dayOffPlan
        var dataSelected = newData["\(selectedWeek)"] as! [String: Any]
        dataSelected["\(selectedDay)"] = NSNull()
        dayOffPlan["\(selectedWeek)"] = dataSelected
        
        if listShift == nil {
            tableView.isHidden = true
            emptyImage.isHidden = false
            setWorkButton.setTitle("Set Work Day", for: .normal)
        }else{
            tableView.isHidden = false
            emptyImage.isHidden = true
            tableView.reloadData()
            setWorkButton.setTitle("Set To DayOff", for: .normal)
        }
        
        colectionView.reloadData()
    }
    
    
}
