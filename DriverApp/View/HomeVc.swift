//
//  HomeVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD
import CoreLocation
import LanguageManager_iOS

@available(iOS 13.0, *)
class HomeVc: UIViewController {
    
    private var manager: CLLocationManager?
    private var driverManager: CLLocationManager?
    
    var inOutVm = InOutViewModel()
    var origin: Origin? = nil
    
//    var noteVm = NoteViewModel()
//    var pendingNotes: [Note]!
    
    var allowReject: Bool = true
    var totalReject: Int = 0
    
    var expanded: Bool = false
    
    var databaseManager = DatabaseManager()
    
    var profileVm = ProfileViewModel()
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    
    var orderViewModel = OrderViewModel()
    var orderData: [OrderListDate]?
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.register(OrderCell.self, forCellReuseIdentifier: OrderCell.id)
        table.register(PendingCell.self, forCellReuseIdentifier: PendingCell.id)
        table.backgroundColor = .white
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = 0
        return table
    }()
    
    let arrowRight: UIImageView = {
       let img = UIImageView()
        let imageAset = UIImage(named: "arrowRight")
        let baru = imageAset?.resizeImage(CGSize(width: 20, height: 20))
        img.image = baru
        img.layer.masksToBounds = true
        img.contentMode = .right
        return img
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localiz())
        refreshControl.addTarget(self, action: #selector(getDataOrder), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        
        configureNavigationBar()
        
    }
    
    private func getCurrentPosition(){
        manager = CLLocationManager()
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        manager?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        configureNavigationBar()
        
        driverManager = CLLocationManager()
        driverManager?.requestWhenInUseAuthorization()
        driverManager?.startUpdatingLocation()
        driverManager?.startUpdatingHeading()
        driverManager?.delegate = self
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = formater.string(from: date)
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        if let session = UserDefaults.standard.value(forKey: "userSession") as? [String: Any] {
            if session["date"] as? String != dateString {
                let data: [String: Any] = [
                    "code_driver": codeDriver,
                    "date": dateString
                ]
                UserDefaults.standard.setValue(data, forKey: "userSession")
                getCurrentPosition()
            }else {
                guard let currentDriver = session["code_driver"] as? String  else {
                    return
                }
                if  currentDriver != codeDriver {
                    let data: [String: Any] = [
                        "code_driver": codeDriver,
                        "date": dateString
                    ]
                    UserDefaults.standard.setValue(data, forKey: "userSession")
                    getCurrentPosition()
                }else {
                    getDataOrder()
                }
            }
        }else {
            print("tidak ada data")
            let data: [String: Any] = [
                "code_driver": codeDriver,
                "date": dateString
            ]
            UserDefaults.standard.setValue(data, forKey: "userSession")
            getCurrentPosition()
        }
        
        cekStatusReject()
    }

    
    private func upateLocation(){
        print("update Location")
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let lat = origin?.latitude,
              let long = origin?.longitude  else {
            print("No user data")
            return
        }
        let data: CheckinData = CheckinData(code_driver: codeDriver, lat: String(lat), long: String(long))
        spiner.show(in: view)
        inOutVm.updateLastPosition(data: data) { (res) in
            switch res {
                
            case .success(let oke):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    if oke {
                        self.getDataOrder()
                    }
                }
            case .failure(_):
                self.spiner.dismiss()
            }
        }
    }
    
    @objc
    func getDataOrder(){
        print("order")
        // get data detail user from local
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        
        orderViewModel.getDataOrder(codeDriver: codeDriver) {[weak self] (res) in
            switch res {
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self?.orderData = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                }
            case .success(let order):
                DispatchQueue.main.async {
                    self?.orderData = order
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func cekStatusReject(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let status = userData["status"] as? String, status == "freelance" else {
            print("status")
            return
        }
        
        orderViewModel.cekRejectOrder(driver: codeDriver) {[weak self] (res) in
            switch res {
            case.success(let data):
                DispatchQueue.main.async {
                    let reject = data.data
                    self?.totalReject = reject
                    if reject < 2 {
                        self?.allowReject = true
                    }else {
                        self?.allowReject = false
                    }
                }
            case .failure(let err):
                print(err)
                self?.allowReject = true
            }
        }
    }
    
    func configureNavigationBar(){
        let imageChat = UIImage(named: "chatIcon")
        let imageProfile = UIImage(named: "profileIcon")
        let imageRest = UIImage(named: "rest")
        let chat = imageChat?.resizeImage(CGSize(width: 25, height: 25))
        let profile = imageProfile?.resizeImage(CGSize(width: 25, height: 25))
        let rest = imageRest?.resizeImage(CGSize(width: 25, height: 25))
        
        navigationItem.title = "Job List".localiz()
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



//MARK: - TABLE VIEW ORDER
@available(iOS 13.0, *)
extension HomeVc: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let orderData = orderData {
            return orderData.count
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
           let v = UIView()
            let v2 = UIView()
            let lableDelivery = Reusable.makeLabel(text: "DELIVERY LIST ORDER".localiz(), font: UIFont.systemFont(ofSize: 16, weight: .medium), color: UIColor(named: "orangeKasumi")!)
            
            v.addSubview(v2)
            v2.anchor(top: v.topAnchor, left: v.leftAnchor, right: v.rightAnchor, paddingTop: 5, height: 1)
            
            v.addSubview(lableDelivery)
            lableDelivery.anchor(left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, paddingLeft: 10, paddingRight: 10)
            v2.backgroundColor = UIColor(named: "orangeKasumi")
           return v
        }
        return nil
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderData = orderData {
            if orderData[section].order_list != nil {
                return orderData[section].order_list!.count
            }else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOrder = tableView.dequeueReusableCell(withIdentifier: OrderCell.id, for: indexPath) as! OrderCell
        
        let cellPending = tableView.dequeueReusableCell(withIdentifier: PendingCell.id, for: indexPath) as! PendingCell
        
        if let order = orderData {
            cellOrder.orderData = order[indexPath.section].order_list![indexPath.row]
            cellPending.orderData = order[indexPath.section].order_list![indexPath.row]
        }
        
        guard let orderData = orderData else {
            return UITableViewCell()
        }
        
       let item = orderData[indexPath.section].order_list![indexPath.row]
    
        if item.status_tracking == "pending" {
            return cellPending
        }else {
            return cellOrder
        }
        
    }
    
    class DateHeaderHome: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            textColor = UIColor(named: "darkKasumi")
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize{
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width, height: height)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = DateHeaderHome()
        
        let containerLabel = UIView()
        containerLabel.addSubview(label)
        
        label.anchor(top: containerLabel.topAnchor, left: containerLabel.leftAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 2, paddingBottom: 2, paddingLeft: 10, paddingRight: 10)
    
        
        if let order = orderData {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy/MM/dd"
            let date = dateFormater.date(from: order[section].date)
            let dateString = dateFormater.string(from: date!)
            
            let dateStringNow = dateFormater.string(from: Date())
            
            let value = dateString == dateStringNow ? "Today".localiz() : dateString
            
            let totalOrderList = order[section].order_list
            
            label.text = "\(value) (\(totalOrderList?.count ?? 0))"
            
            
            return containerLabel
        }
  
        return nil
               
       }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let orderData = orderData {
            let order = orderData[indexPath.section].order_list![indexPath.row]
            
            let vc = LiveTrackingVC()
            vc.order = order
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            print(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
 
        let rejectAction = UIContextualAction(
            style: .normal,
            title: "Decline".localiz(),
            handler: {[weak self](action, view, completion) in
                   completion(true)
                
                guard let allorder = self?.orderData,
                      let dateOrder = allorder[indexPath.section].order_list,
                      let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                            let codeDriver = userData["codeDriver"] as? String  else {return}
                
                let orderNo = dateOrder[indexPath.row].order_number
                
                let data: DeleteHistory = DeleteHistory(order_number: orderNo, code_driver: codeDriver)
                if self!.totalReject >= 2 {
                    return
                }
                
                
                self?.orderViewModel.rejectOrder(data: data) {[weak self] (res) in
                    switch res {
                    case .failure(_):
                        Helpers().showAlert(view: self!, message: "Failed to decline this order !".localiz())
                    case .success(let oke):
                        if oke {
                            self?.orderData![indexPath.section].order_list?.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .middle)
                            self?.totalReject += 1
                            if self!.totalReject >= 2{
                                self?.allowReject = false
                            }
                            self?.tableView.reloadData()
                        }
                    }

                }
                
           })
        
        let pendingAction = UIContextualAction(
            style: .normal,
            title: "Pending".localiz(),
            handler: {[weak self](action, view, completion) in
                   completion(true)
                let vc = PendingNoteVc()
                if let order = self?.orderData {
                    if order[indexPath.section].order_list != nil {
                        let orderList = order[indexPath.section].order_list
                        vc.orderData = orderList![indexPath.row]
                    }
                }
                
                let navVc = UINavigationController(rootViewController: vc)
                self?.present(navVc, animated: true, completion: nil)
           })


        let imageDelete = UIImage(named: "remove")
        let delete = imageDelete?.resizeImage(CGSize(width: 25, height: 25))
        
        let imageEdit = UIImage(named: "time")
        let edit = imageEdit?.resizeImage(CGSize(width: 25, height: 25))
    
        rejectAction.image = delete
        rejectAction.backgroundColor = UIColor(named: "darkKasumi")
        pendingAction.image = edit
        pendingAction.backgroundColor = UIColor(named: "grayKasumi")
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any], let statusDriver = userData["status"] as? String  else {return nil}
        let actions = statusDriver == "freelance" && allowReject ? [rejectAction] : []
        
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}


@available(iOS 13.0, *)
extension HomeVc: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            self.origin = Origin(latitude: coordinate.latitude, longitude: coordinate.longitude)
            if manager != driverManager {
                self.upateLocation()
            }
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String,
                  let idDriver = userData["idDriver"] as? Int else {
                return
            }
            databaseManager.updateData(idDriver: String(idDriver), codeDriver: codeDriver, lat: coordinate.latitude, lng: coordinate.longitude, status: "active",bearing: location.course) {[weak self] (res) in
                switch res {
                case .failure(let err):
                    print(err)
                case .success(let oke):
                    if oke {
                        self?.driverManager?.stopUpdatingLocation()
                    }
                }
            }
            manager.stopUpdatingLocation()
        }
    }
    
}
