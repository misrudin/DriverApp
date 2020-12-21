//
//  DayOffViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

@available(iOS 13.0, *)
class DayOffVc: UIViewController {
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
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var dayOfVm = DayOffViewModel()
    var dataDayOff: DayOffStatus!
    var listShift: [Int]? = nil
    var dayOffPlan: DayOfParent? = nil
    
    var shiftTimeVm = ShiftTimeViewModel()
    
    var shiftTime = [ShiftTime]()
    
    var profileVm = ProfileViewModel()
    
    
    var dayOff:[String: Any]!
    
    let daysInMounth = Date().daysInMonth()
    
    var selectedIndex: Int?
    
    let months: [String] = ["January".localiz(),
                            "February".localiz(),
                            "March".localiz(),
                            "April".localiz(),
                            "May".localiz(),
                            "June".localiz(),
                            "July".localiz(),
                            "August".localiz(),
                            "September".localiz(),
                            "October".localiz(),
                            "November".localiz(),
                            "December".localiz()]
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = months[Calendar.current.component(.month, from: Date())-1]
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    
    lazy var dayOffLable: UILabel = {
        let label = UILabel()
        label.text = "Day Off".localiz()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 30,weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private let planButotn: UIButton={
        let button = UIButton()
        button.setTitle("Plan Next Month".localiz(), for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular )
        button.addTarget(self, action: #selector(setPlanClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    //MARK:- Colection view
    
    private let colectionViewDayoff: UICollectionView = {
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
        label.text = "Shift on this date".localiz()
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
//        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
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
        getListShiftTime()
        
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
    
    private func getData(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        spiner.show(in: view)
        dayOfVm.getDataDayOff(codeDriver: codeDriver) {[weak self] (success) in
            switch success {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.dataDayOff = data.data.dayOfStatus
                    self?.dayOffPlan = data.data
                    self?.spiner.dismiss()
                    self?.colectionViewDayoff.reloadData()
                    self?.scrollToDate()
                    if data.currentWeek == "3" {
                        self?.planButotn.isHidden = false
                    }else {
                        self?.planButotn.isHidden = true
                    }
                }
            case .failure(let error):
                print(error)
                self?.spiner.dismiss()
                self?.colectionViewDayoff.reloadData()
                self?.scrollToDate()
            }
        }
    }
    
    private func scrollToDate(){
        let date = Date()
        let dateFor = DateFormatter()
        dateFor.dateFormat = "dd"
        
        let dateToday = dateFor.string(from: date)
        let dateInt: Int = Int(dateToday)!
        let index: IndexPath = IndexPath(item: dateInt-1, section: 0)
        colectionViewDayoff.scrollToItem(at: index, at: .left, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(planButotn)
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        view.addSubview(colectionViewDayoff)
        colectionViewDayoff.delegate = self
        colectionViewDayoff.dataSource = self
        
        
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
                listShift = dataDayOff != nil ? dataDayOff.week1.Sun : nil
            case "Mon":
                listShift = dataDayOff != nil ? dataDayOff.week1.Mon : nil
            case "Tue":
                listShift = dataDayOff != nil ? dataDayOff.week1.Tue : nil
            case "Wed":
                listShift = dataDayOff != nil ? dataDayOff.week1.Wed : nil
            case "Thu":
                listShift = dataDayOff != nil ? dataDayOff.week1.Thu : nil
            case "Fri":
                listShift = dataDayOff != nil ? dataDayOff.week1.Fri : nil
            default:
                listShift = dataDayOff != nil ? dataDayOff.week1.Sat : nil
            }
        }
        if week2 {
            switch day {
            case "Sun":
                listShift = dataDayOff != nil ? dataDayOff.week2.Sun : nil
            case "Mon":
                listShift = dataDayOff != nil ? dataDayOff.week2.Mon : nil
            case "Tue":
                listShift = dataDayOff != nil ? dataDayOff.week2.Tue : nil
            case "Wed":
                listShift = dataDayOff != nil ? dataDayOff.week2.Wed : nil
            case "Thu":
                listShift = dataDayOff != nil ? dataDayOff.week2.Thu : nil
            case "Fri":
                listShift = dataDayOff != nil ? dataDayOff.week2.Fri : nil
            default:
                listShift = dataDayOff != nil ? dataDayOff.week2.Sat : nil
            }
        }
        if week3 {
            switch day {
            case "Sun":
                listShift = dataDayOff != nil ? dataDayOff.week3.Sun : nil
            case "Mon":
                listShift = dataDayOff != nil ? dataDayOff.week3.Mon : nil
            case "Tue":
                listShift = dataDayOff != nil ? dataDayOff.week3.Tue : nil
            case "Wed":
                listShift = dataDayOff != nil ? dataDayOff.week3.Wed : nil
            case "Thu":
                listShift = dataDayOff != nil ? dataDayOff.week3.Thu : nil
            case "Fri":
                listShift = dataDayOff != nil ? dataDayOff.week3.Fri : nil
            default:
                listShift = dataDayOff != nil ? dataDayOff.week3.Sat : nil
            }
        }
        if week4 {
            switch day {
            case "Sun":
                listShift = dataDayOff != nil ? dataDayOff.week4.Sun : nil
            case "Mon":
                listShift = dataDayOff != nil ? dataDayOff.week4.Mon : nil
            case "Tue":
                listShift = dataDayOff != nil ? dataDayOff.week4.Tue : nil
            case "Wed":
                listShift = dataDayOff != nil ? dataDayOff.week4.Wed : nil
            case "Thu":
                listShift = dataDayOff != nil ? dataDayOff.week4.Thu : nil
            case "Fri":
                listShift = dataDayOff != nil ? dataDayOff.week4.Fri : nil
            default:
                listShift = dataDayOff != nil ? dataDayOff.week4.Sat : nil
            }
        }
        
        if week5 {
            switch day {
            case "Sun":
                listShift = dataDayOff != nil ? dataDayOff.week5.Sun : nil
            case "Mon":
                listShift = dataDayOff != nil ? dataDayOff.week5.Mon : nil
            case "Tue":
                listShift = dataDayOff != nil ? dataDayOff.week5.Tue : nil
            case "Wed":
                listShift = dataDayOff != nil ? dataDayOff.week5.Wed : nil
            case "Thu":
                listShift = dataDayOff != nil ? dataDayOff.week5.Thu : nil
            case "Fri":
                listShift = dataDayOff != nil ? dataDayOff.week5.Fri : nil
            default:
                listShift = dataDayOff != nil ? dataDayOff.week5.Sat : nil
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
        
        colectionViewDayoff.anchor(top: planButotn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 100)
        
        contrainerView.anchor(top: colectionViewDayoff.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        
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
        
        navigationItem.title = "Day Off Driver".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    
        let button1 = UIBarButtonItem(image: rest, style: .plain, target: self, action: #selector(onClickRest))
        
        let button2 = UIBarButtonItem(image: chat, style: .plain, target: self, action: #selector(onClickChatButton))
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        navigationItem.leftBarButtonItems = [button1,button2]
        
        profileVm.cekStatusDriver(codeDriver: codeDriver) { (res) in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.checkinTime != nil {
                        if data.workTime != nil {
                            self.navigationItem.leftBarButtonItems = [button2]
                        }else {
                            self.navigationItem.leftBarButtonItems = [button1, button2]
                        }
                    }else {
                        self.navigationItem.leftBarButtonItems = [button2]
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.navigationItem.leftBarButtonItems = [button2]
                }
            }
        }
        
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
        let vc = ChatView()
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
            let filtered = shiftTime.filter({$0.id_shift_time == data[indexPath.row]})
            cell.shiftTime = filtered[0]
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
            cell.borderBotom.isHidden = false
        }else {
            cell.borderBotom.isHidden = true
        }
        
        if selectedIndex != nil && selectedIndex == i {
            cell.borderBotomSelected.isHidden = false
        }else {
            cell.borderBotomSelected.isHidden = true
        }
        
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
            cell.weekLabel.text = "w1"
            switch dayName {
            case "Sun":
                if dataDayOff != nil && dataDayOff.week1.Sun != nil && dataDayOff.week1.Sun?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Sun ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataDayOff != nil && dataDayOff.week1.Mon != nil  && dataDayOff.week1.Mon?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Mon ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataDayOff != nil && dataDayOff.week1.Tue != nil  && dataDayOff.week1.Tue?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Tue ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataDayOff != nil && dataDayOff.week1.Wed != nil  && dataDayOff.week1.Wed?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Wed ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataDayOff != nil && dataDayOff.week1.Thu != nil  && dataDayOff.week1.Thu?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Thu ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataDayOff != nil && dataDayOff.week1.Fri != nil  && dataDayOff.week1.Fri?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Fri ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataDayOff != nil && dataDayOff.week1.Sat != nil  && dataDayOff.week1.Sat?.count != 0 {
                    let array:[Int]? = dataDayOff.week1.Sat ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 2
        if week2 {
            cell.weekLabel.text = "w2"
            switch dayName {
            case "Sun":
                if dataDayOff != nil && dataDayOff.week2.Sun != nil && dataDayOff.week2.Sun?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Sun ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataDayOff != nil && dataDayOff.week2.Mon != nil  && dataDayOff.week2.Mon?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Mon ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataDayOff != nil && dataDayOff.week2.Tue != nil  && dataDayOff.week2.Tue?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Tue ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataDayOff != nil && dataDayOff.week2.Wed != nil  && dataDayOff.week2.Wed?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Wed ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataDayOff != nil && dataDayOff.week2.Thu != nil  && dataDayOff.week2.Thu?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Thu ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataDayOff != nil && dataDayOff.week2.Fri != nil  && dataDayOff.week2.Fri?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Fri ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataDayOff != nil && dataDayOff.week2.Sat != nil  && dataDayOff.week2.Sat?.count != 0 {
                    let array:[Int]? = dataDayOff.week2.Sat ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 3
        if week3 {
            cell.weekLabel.text = "w3"
            switch dayName {
            case "Sun":
                if dataDayOff != nil && dataDayOff.week3.Sun != nil && dataDayOff.week3.Sun?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Sun ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataDayOff != nil && dataDayOff.week3.Mon != nil  && dataDayOff.week3.Mon?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Mon ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataDayOff != nil && dataDayOff.week3.Tue != nil  && dataDayOff.week3.Tue?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Tue ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataDayOff != nil && dataDayOff.week3.Wed != nil  && dataDayOff.week3.Wed?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Wed ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataDayOff != nil && dataDayOff.week3.Thu != nil  && dataDayOff.week3.Thu?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Thu ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataDayOff != nil && dataDayOff.week3.Fri != nil  && dataDayOff.week3.Fri?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Fri ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataDayOff != nil && dataDayOff.week3.Sat != nil  && dataDayOff.week3.Sat?.count != 0 {
                    let array:[Int]? = dataDayOff.week3.Sat ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 4
        if week4 {
            cell.weekLabel.text = "w4"
            switch dayName {
            case "Sun":
                if dataDayOff != nil && dataDayOff.week4.Sun != nil && dataDayOff.week4.Sun?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Sun ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataDayOff != nil && dataDayOff.week4.Mon != nil  && dataDayOff.week4.Mon?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Mon ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataDayOff != nil && dataDayOff.week4.Tue != nil  && dataDayOff.week4.Tue?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Tue ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataDayOff != nil && dataDayOff.week4.Wed != nil  && dataDayOff.week4.Wed?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Wed ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataDayOff != nil && dataDayOff.week4.Thu != nil  && dataDayOff.week4.Thu?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Thu ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataDayOff != nil && dataDayOff.week4.Fri != nil  && dataDayOff.week4.Fri?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Fri ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataDayOff != nil && dataDayOff.week4.Sat != nil  && dataDayOff.week4.Sat?.count != 0 {
                    let array:[Int]? = dataDayOff.week4.Sat ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        //MARK: - Week 5
        if week5 {
            cell.weekLabel.text = "w5"
            switch dayName {
            case "Sun":
                if dataDayOff != nil && dataDayOff.week5.Sun != nil && dataDayOff.week5.Sun?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Sun ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Mon":
                if dataDayOff != nil && dataDayOff.week5.Mon != nil  && dataDayOff.week5.Mon?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Mon ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift".localiz()
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Tue":
                if dataDayOff != nil && dataDayOff.week5.Tue != nil  && dataDayOff.week5.Tue?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Tue ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Wed":
                if dataDayOff != nil && dataDayOff.week5.Wed != nil  && dataDayOff.week5.Wed?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Wed ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Thu":
                if dataDayOff != nil && dataDayOff.week5.Thu != nil  && dataDayOff.week5.Thu?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Thu ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            case "Fri":
                if dataDayOff != nil && dataDayOff.week5.Fri != nil  && dataDayOff.week5.Fri?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Fri ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            default:
                if dataDayOff != nil && dataDayOff.week5.Sat != nil  && dataDayOff.week5.Sat?.count != 0 {
                    let array:[Int]? = dataDayOff.week5.Sat ?? nil
                    cell.container2.backgroundColor = bgColor1
                    cell.statusLable.text = "\(array?.count ?? 0) Shift"
                    cell.dayLable.textColor = color1
                    cell.dateLable.textColor = color1
                }else {
                    cell.container2.backgroundColor = bgColor2
                    cell.statusLable.text = "Day Off".localiz()
                    cell.dayLable.textColor = color2
                    cell.dateLable.textColor = color2
                }
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = indexPath.row + 1
     
        let date = Date.dateStringFrom(customDate: i)
        let dayName = Date.dayNameFromCustomDate(customDate: i)
        
        selectedIndex = i
        colectionViewDayoff.reloadData()

        btnTouch(tanggal: date, day: dayName, index: i)
    }
}

