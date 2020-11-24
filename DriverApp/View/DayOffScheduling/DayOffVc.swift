//
//  DayOffViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import JGProgressHUD

@available(iOS 13.0, *)
class DayOffVc: UIViewController {
    
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
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    var dayOfVm = DayOffViewModel()
    var dataDayOff: DayOffStatus!
    var listShift: [Int]? = nil
    var dayOffPlan: DayOfParent? = nil
    
    
    var dayOff:[String: Any]!
    
    let daysInMounth = Date().daysInMonth()
    
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
        vc.dayOffPlanData = dayOffPlan
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    MARK: - Liveciclye
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureNavigationBar()
        
        getData()
        
    }
    
    private func getData(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        spiner.show(in: view)
        dayOfVm.getDataDayOff(codeDriver: codeDriver) { (success) in
            switch success {
            case .success(let data):
                DispatchQueue.main.async {
//                    self.dataDayOff = data.dayOfStatus
                    self.getDataDayOff(data: data.dayOfStatus)
                    self.dayOffPlan = data
                    self.spiner.dismiss()
                    self.colectionView.reloadData()
                    print(data)
                }
            case .failure(let error):
                print(error)
                self.spiner.dismiss()
                self.colectionView.reloadData()
            }
        }
    }
    
    //MARK:- Get day off
    func getDataDayOff(data: DayOffStatus){
        
        print(data)
        
        guard let data = dataDayOff else {return}
      
            var week1: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week2: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week3: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week4: [String: Any] = NSMutableDictionary() as! [String : Any]
            var week5: [String: Any] = NSMutableDictionary() as! [String : Any]
            let dataWeek1 = data.week1
            let dataWeek2 = data.week2
            let dataWeek3 = data.week3
            let dataWeek4 = data.week4
            let dataWeek5 = data.week5
            week1["Sunday"] = dataWeek1.Sun == nil || dataWeek1.Sun?.count == 0 ? NSNull() : dataWeek1.Sun
            week1["Monday"] = dataWeek1.Mon == nil || dataWeek1.Sun?.count == 0 ? NSNull() : dataWeek1.Mon
            week1["Tuesday"] = dataWeek1.Tue == nil || dataWeek1.Tue?.count == 0 ? NSNull() : dataWeek1.Tue
            week1["Wednesday"] = dataWeek1.Wed == nil || dataWeek1.Wed?.count == 0 ? NSNull() : dataWeek1.Wed
            week1["Thursday"] = dataWeek1.Thu == nil || dataWeek1.Thu?.count == 0 ? NSNull() : dataWeek1.Thu
            week1["Friday"] = dataWeek1.Fri == nil || dataWeek1.Fri?.count == 0 ? NSNull() : dataWeek1.Fri
            week1["Saturday"] = dataWeek1.Sat == nil || dataWeek1.Sat?.count == 0 ? NSNull() : dataWeek1.Sat
            
            week2["Sunday"] = dataWeek2.Sun == nil || dataWeek2.Sun?.count == 0 ? NSNull() : dataWeek2.Sun
            week2["Monday"] = dataWeek2.Mon == nil || dataWeek2.Sun?.count == 0 ? NSNull() : dataWeek2.Mon
            week2["Tuesday"] = dataWeek2.Tue == nil || dataWeek2.Tue?.count == 0 ? NSNull() : dataWeek2.Tue
            week2["Wednesday"] = dataWeek2.Wed == nil || dataWeek2.Wed?.count == 0 ? NSNull() : dataWeek2.Wed
            week2["Thursday"] = dataWeek2.Thu == nil || dataWeek2.Thu?.count == 0 ? NSNull() : dataWeek2.Thu
            week2["Friday"] = dataWeek2.Fri == nil || dataWeek2.Fri?.count == 0 ? NSNull() : dataWeek2.Fri
            week2["Saturday"] = dataWeek2.Sat == nil || dataWeek2.Sat?.count == 0 ? NSNull() : dataWeek2.Sat
            
            week3["Sunday"] = dataWeek3.Sun == nil || dataWeek3.Sun?.count == 0 ? NSNull() : dataWeek3.Sun
            week3["Monday"] = dataWeek3.Mon == nil || dataWeek3.Sun?.count == 0 ? NSNull() : dataWeek3.Mon
            week3["Tuesday"] = dataWeek3.Tue == nil || dataWeek3.Tue?.count == 0 ? NSNull() : dataWeek3.Tue
            week3["Wednesday"] = dataWeek3.Wed == nil || dataWeek3.Wed?.count == 0 ? NSNull() : dataWeek3.Wed
            week3["Thursday"] = dataWeek3.Thu == nil || dataWeek3.Thu?.count == 0 ? NSNull() : dataWeek3.Thu
            week3["Friday"] = dataWeek3.Fri == nil || dataWeek3.Fri?.count == 0 ? NSNull() : dataWeek3.Fri
            week3["Saturday"] = dataWeek3.Sat == nil || dataWeek3.Sat?.count == 0 ? NSNull() : dataWeek3.Sat
            
            week4["Sunday"] = dataWeek4.Sun == nil || dataWeek4.Sun?.count == 0 ? NSNull() : dataWeek4.Sun
            week4["Monday"] = dataWeek4.Mon == nil || dataWeek4.Sun?.count == 0 ? NSNull() : dataWeek4.Mon
            week4["Tuesday"] = dataWeek4.Tue == nil || dataWeek4.Tue?.count == 0 ? NSNull() : dataWeek4.Tue
            week4["Wednesday"] = dataWeek4.Wed == nil || dataWeek4.Wed?.count == 0 ? NSNull() : dataWeek4.Wed
            week4["Thursday"] = dataWeek4.Thu == nil || dataWeek4.Thu?.count == 0 ? NSNull() : dataWeek4.Thu
            week4["Friday"] = dataWeek4.Fri == nil || dataWeek4.Fri?.count == 0 ? NSNull() : dataWeek4.Fri
            week4["Saturday"] = dataWeek4.Sat == nil || dataWeek4.Sat?.count == 0 ? NSNull() : dataWeek4.Sat
            
            week5["Sunday"] = dataWeek5.Sun == nil || dataWeek5.Sun?.count == 0 ? NSNull() : dataWeek5.Sun
            week5["Monday"] = dataWeek5.Mon == nil || dataWeek5.Sun?.count == 0 ? NSNull() : dataWeek5.Mon
            week5["Tuesday"] = dataWeek5.Tue == nil || dataWeek5.Tue?.count == 0 ? NSNull() : dataWeek5.Tue
            week5["Wednesday"] = dataWeek5.Wed == nil || dataWeek5.Wed?.count == 0 ? NSNull() : dataWeek5.Wed
            week5["Thursday"] = dataWeek5.Thu == nil || dataWeek5.Thu?.count == 0 ? NSNull() : dataWeek5.Thu
            week5["Friday"] = dataWeek5.Fri == nil || dataWeek5.Fri?.count == 0 ? NSNull() : dataWeek5.Fri
            week5["Saturday"] = dataWeek5.Sat == nil || dataWeek5.Sat?.count == 0 ? NSNull() : dataWeek5.Sat
            
            self.dayOff = [
                "1": week1,
                "2": week2,
                "3": week3,
                "4": week4,
                "5": week5,
            ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(planButotn)
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        view.addSubview(colectionView)
        self.colectionView.delegate = self
        self.colectionView.dataSource = self
        
        
        view.addSubview(contrainerView)
        contrainerView.addSubview(dateLabel)
        contrainerView.addSubview(subTitleLabel)
        contrainerView.addSubview(tableView)
        contrainerView.addSubview(emptyImage)
        
        
        configureLayout()
        todayDate()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyImage.dropShadow(color: UIColor(named: "orangeKasumi")!, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 120/2, scale: true)
        contrainerView.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 5, scale: true)
    }
    
    
    func todayDate(){
        let date = Date()
        let dateFor = DateFormatter()
        dateFor.dateFormat = "EE, dd MMM Y"
        
        let dayString = dateFor.string(from: date)
        dateLabel.text = dayString
    }
    
//    @objc
    private func btnTouch(tanggal: String, day: String, index: Int){
        let date = Date.dayStringFromStringDate(customDate: tanggal)
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
        
        if listShift == nil || listShift?.count == 0 {
            tableView.isHidden = true
            emptyImage.isHidden = false
        }else{
            tableView.isHidden = false
            emptyImage.isHidden = true
            tableView.reloadData()
        }
       
    }
    
   
    
    func configureLayout(){
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: planButotn.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        planButotn.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16,width: 200, height: 30)
        
        colectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 100)
        
        contrainerView.anchor(top: colectionView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        
        contrainerView.dropShadow(color: UIColor.blue, opacity: 1, offSet: CGSize(width: 5, height: 5), radius: 5, scale: false)
        subTitleLabel.anchor(top: contrainerView.topAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        dateLabel.anchor(top: subTitleLabel.bottomAnchor, left: contrainerView.leftAnchor, right: contrainerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        tableView.anchor(top: dateLabel.bottomAnchor, left: contrainerView.leftAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 20, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        
//        dayOffLable.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.centerYAnchor.constraint(equalTo: contrainerView.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: contrainerView.centerXAnchor).isActive = true
    }
    
    
    func configureNavigationBar(){
        let imageChat = UIImage(named: "chatIcon")
        let imageProfile = UIImage(named: "profileIcon")
        let imageRest = UIImage(named: "rest")
        let chat = imageChat?.resizeImage(CGSize(width: 25, height: 25))
        let profile = imageProfile?.resizeImage(CGSize(width: 25, height: 25))
        let rest = imageRest?.resizeImage(CGSize(width: 25, height: 25))
        
        navigationItem.title = "Day Off Driver"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    
        let button1 = UIBarButtonItem(image: rest, style: .plain, target: self, action: #selector(onClickRest))
        
        let button2 = UIBarButtonItem(image: chat, style: .plain, target: self, action: #selector(onClickChatButton))
        navigationItem.leftBarButtonItems = [button1,button2]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profile, style: .plain, target: self, action: #selector(onClickProfiile))

        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    func onClickRest(){
        let vc = RestViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func onClickProfiile(){
        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

@available(iOS 13.0, *)
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



//MARK:- colection view
@available(iOS 13.0, *)
extension DayOffVc: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMounth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanCell.id, for: indexPath) as! PlanCell
        
        let date = Date()
        let dateFor = DateFormatter()
        dateFor.dateFormat = "dd"
        
        let dateToday = dateFor.string(from: date)
        
        let i = indexPath.row + 1
        let dayName = Date.dayNameFromCustomDate(customDate: i)
        let dateLable = "\(i < 10 ? "\(0)\(i)" : "\(i)")"
        
        cell.dayLable.text = dayName
        cell.dateLable.text = dateLable
        
        if "\(i < 10 ? "\(0)\(i)" : "\(i)")" == "\(dateToday)" {
            cell.container2.isHidden = false
        }else {
            cell.container2.isHidden = true
        }
        
//        //jumlah shift dan hari apa ini?
//        let week1 = i <= 7
//        let week2 = i > 7 && i <= 14
//        let week3 = i > 14 && i <= 21
//        let week4 = i > 21 && i <= 28
//        let week5 = i > 28
//
//        let color1: UIColor = .black
//        let color2: UIColor = .black
//
//        //MARK: - Week 1
//        if week1 {
//            let dataWeek = dayOff["1"] as! [String: Any]
//            switch dayName {
//            case "Sun":
//                if dataWeek["Sunday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Mon":
//                if dataWeek["Monday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Monday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Tue":
//                if dataWeek["Tuesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Wed":
//                if dataWeek["Wednesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Thu":
//                if dataWeek["Thursday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Fri":
//                if dataWeek["Friday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Friday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            default:
//                if dataWeek["Saturday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            }
//        }
//
//
//        //MARK: - Week 2
//        if week2 {
//            let dataWeek = dayOff["2"] as! [String: Any]
//            switch dayName {
//            case "Sun":
//                if dataWeek["Sunday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Mon":
//                if dataWeek["Monday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Monday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Tue":
//                if dataWeek["Tuesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Wed":
//                if dataWeek["Wednesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Thu":
//                if dataWeek["Thursday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Fri":
//                if dataWeek["Friday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Friday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            default:
//                if dataWeek["Saturday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            }
//        }
//
//        //MARK: - Week 3
//        if week3 {
//            let dataWeek = dayOff["3"] as! [String: Any]
//            switch dayName {
//            case "Sun":
//                if dataWeek["Sunday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Mon":
//                if dataWeek["Monday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Monday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Tue":
//                if dataWeek["Tuesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Wed":
//                if dataWeek["Wednesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Thu":
//                if dataWeek["Thursday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Fri":
//                if dataWeek["Friday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Friday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            default:
//                if dataWeek["Saturday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            }
//        }
//
//        //MARK: - Week 4
//        if week4 {
//            let dataWeek = dayOff["4"] as! [String: Any]
//            switch dayName {
//            case "Sun":
//                if dataWeek["Sunday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Mon":
//                if dataWeek["Monday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Monday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Tue":
//                if dataWeek["Tuesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Wed":
//                if dataWeek["Wednesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Thu":
//                if dataWeek["Thursday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Fri":
//                if dataWeek["Friday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Friday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            default:
//                if dataWeek["Saturday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            }
//        }
//
//        //MARK: - Week 5
//        if week5 {
//            let dataWeek = dayOff["5"] as! [String: Any]
//            switch dayName {
//            case "Sun":
//                if dataWeek["Sunday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Sunday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Mon":
//                if dataWeek["Monday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Monday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Tue":
//                if dataWeek["Tuesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Tuesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Wed":
//                if dataWeek["Wednesday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Wednesday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Thu":
//                if dataWeek["Thursday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Thursday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            case "Fri":
//                if dataWeek["Friday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Friday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            default:
//                if dataWeek["Saturday"] as? [Int] != nil {
//                    let array:[Int]? = dataWeek["Saturday"] as? [Int]
//                    cell.container2.backgroundColor = UIColor(named: "colorYellow")
//                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
//                    cell.dayLable.textColor = color1
//                    cell.dateLable.textColor = color1
//                }else {
//                    cell.container2.backgroundColor = UIColor(named: "colorGray")
//                    cell.statusLable.text = "Day Off"
//                    cell.dayLable.textColor = color2
//                    cell.dateLable.textColor = color2
//                }
//            }
//        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = indexPath.row + 1
     
        let date = Date.dateStringFrom(customDate: i)
        let dayName = Date.dayNameFromCustomDate(customDate: i)

        btnTouch(tanggal: date, day: dayName, index: i)
    }
}

