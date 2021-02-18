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
import Firebase

enum DisplayHomeType {
    case pickup
    case delivery
}

struct DataTable: Decodable {
    var isOpen: Bool
    var data: NewDataOrder
    var shift: ShiftTime
}

@available(iOS 13.0, *)
class HomeVc: UIViewController {
    
    private var manager: CLLocationManager?
    private var driverManager: CLLocationManager?
    
    private var chatObserver: NSObjectProtocol?
    
    var inOutVm = InOutViewModel()
    var origin: Origin? = nil
    
    var allowReject: Bool = true
    var totalReject: Int = 0
    
    var databaseManager = DatabaseManager()
    
    var profileVm = ProfileViewModel()
    
    var shiftTimeVm = ShiftTimeViewModel()
    var activeShift: ShiftTime!
    
    var pickupList: [Pickup]!
    var deliveryList: [NewDelivery]!

    var homeTable = [DataTable]()
    
    var constraint1: NSLayoutConstraint!
    var constraint2: NSLayoutConstraint!
    
    var orderViewModel = OrderViewModel()
    
    var display: DisplayHomeType! = .pickup
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    private let emptyImage: UIView = {
        let view = UIView()
        let imageView: UIImageView = {
           let img = UIImageView()
            img.image = UIImage(named: "emptyImage")
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
    
    private let labelEmpty = Reusable.makeLabel(font: .systemFont(ofSize: 14, weight: .regular), color: UIColor(named: "labelColor")!, numberOfLines: 0, alignment: .center)
    
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.register(OrderCell.self, forCellReuseIdentifier: OrderCell.id)
        table.register(PendingCell.self, forCellReuseIdentifier: PendingCell.id)
        table.backgroundColor = UIColor(named: "whiteKasumi")
        table.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.sectionHeaderHeight = 0
        return table
    }()
    
    let labelTitle = Reusable.makeLabel(text: "DELIVERY LIST ORDER".localiz(), font: .systemFont(ofSize: 15, weight: .medium), color: UIColor(named: "orangeKasumi")!, numberOfLines: 0, alignment: .left)
    
    private let pickupButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Pickup Order".localiz(), for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 40/2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium )
        loginButton.addTarget(self, action: #selector(pickupAllOrder), for: .touchUpInside)
        loginButton.isHidden = true
        return loginButton
    }()
    
    private let deliveryButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Start Delivery".localiz(), for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 40/2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium )
        loginButton.addTarget(self, action: #selector(deliveryAllOrder), for: .touchUpInside)
        loginButton.isHidden = true
        return loginButton
    }()
    
    lazy var finishButton:UIButton = {
        let b = UIButton()
        b.setTitle("Next Shift".localiz(), for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "orangeKasumi")
        b.layer.cornerRadius = 30/2
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular )
        b.addTarget(self, action: #selector(nextShift), for: .touchUpInside)
        return b
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "whiteKasumi")
        
        view.addSubview(tableView)
        view.addSubview(pickupButton)
        view.addSubview(deliveryButton)
        view.addSubview(labelTitle)
        view.addSubview(emptyImage)
        view.addSubview(labelEmpty)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localiz())
        refreshControl.addTarget(self, action: #selector(getListShiftTime), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        configureNavigationBar()
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let idGroup = userData["idGroup"] as? Int else {
            logout()
            return
        }
        
        print("idGroup => ", idGroup)
        
        //button
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.left(toAnchor: view.leftAnchor, space: 10)
        labelTitle.right(toAnchor: view.rightAnchor, space: -10)
        labelTitle.top(toAnchor: view.safeAreaLayoutGuide.topAnchor, space: 10)
        
        pickupButton.translatesAutoresizingMaskIntoConstraints = false
        pickupButton.left(toAnchor: view.leftAnchor, space: 10)
        pickupButton.right(toAnchor: view.rightAnchor, space: -10)
        pickupButton.height(40)
        pickupButton.top(toAnchor: labelTitle.bottomAnchor, space: 10)
        
        deliveryButton.translatesAutoresizingMaskIntoConstraints = false
        deliveryButton.left(toAnchor: view.leftAnchor, space: 10)
        deliveryButton.right(toAnchor: view.rightAnchor, space: -10)
        deliveryButton.height(40)
        deliveryButton.top(toAnchor: labelTitle.bottomAnchor, space: 10)
        
        tableView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelEmpty.anchor(top: emptyImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        labelEmpty.isHidden = true
        
        constraint1 = tableView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10)
        constraint2 = tableView.topAnchor.constraint(equalTo: pickupButton.bottomAnchor, constant: 10)
        pickupButton.isHidden = true
        deliveryButton.isHidden = true
        constraint1.isActive = true
        constraint2.isActive = false
        
        //MARK: - observer
        chatObserver = NotificationCenter.default.addObserver(forName: .didOpenChat,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                let vc = ChatView()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            self.updateToken(token: token)
          }
        }
    
    }
    
    private func updateToken(token: String){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            return
        }
        
        databaseManager.updateToken(codeDriver: codeDriver, token: token) { (res) in
            switch res {
            case .failure(let err): print(err)
            case .success(_): print("succes update token fcm driver")
            }
        }
        
    }
    
    @objc private func nextShift(){
        let vc = NextShiftVc()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func getListShiftTime(){
        spiner.show(in: view)
        shiftTimeVm.getCurrentShiftTime {[weak self] (res) in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.activeShift = data
                    self?.getDataOrder()
                }
            case .failure(let error):
                self?.spiner.dismiss()
                self?.pickupList = []
                self?.deliveryList = []
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.emptyImage.isHidden = false
                self?.labelEmpty.isHidden = false
                self?.labelEmpty.text = error.localizedDescription
                self?.pickupButton.isHidden = true
                self?.deliveryButton.isHidden = true
                self?.constraint1.isActive = true
                self?.constraint2.isActive = false
            }
        }
    }
    
    private func getCurrentPosition(){
        manager = CLLocationManager()
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        manager?.delegate = self
    }
    
    private func logout(){
        UserDefaults.standard.removeObject(forKey: "userData")
        dismiss(animated: true, completion: nil)
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
                    getListShiftTime()
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

    @objc private func pickupAllOrder(){
        let vc = PickupOrderVc()
        vc.hidesBottomBarWhenPushed = true
        vc.shift = activeShift
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func deliveryAllOrder(){
        let vc = DeliveryOrderVc()
        vc.hidesBottomBarWhenPushed = true
        vc.shift = activeShift
        navigationController?.pushViewController(vc, animated: true)
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
                        self.getListShiftTime()
                    }
                }
            case .failure(_):
                self.spiner.dismiss()
            }
        }
    }
    
    private func getDataOrder(){
        print("order")
        // get data detail user from local
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        
        orderViewModel.getDataOrder(codeDriver: codeDriver, shift: activeShift.id_shift_time) {[weak self] (res) in
            switch res {
            case .failure(let err):
                DispatchQueue.main.async {
                    self?.pickupList = []
                    self?.deliveryList = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = false
                    self?.labelEmpty.isHidden = false
                    self?.labelEmpty.text = err.localizedDescription
                    self?.pickupButton.isHidden = true
                    self?.deliveryButton.isHidden = true
                    self?.constraint1.isActive = true
                    self?.constraint2.isActive = false
                    print(err)
                }
            case .success(let order):
                DispatchQueue.main.async {
                    let filterOrder = order.pickup_list?.filter({ ($0.status_tracking == "wait for pickup" || $0.status_tracking == "pending" || $0.status_tracking == "on pickup process") && $0.pickup_store_status == false })
                    
                    let filterOrderDelivery = order.delivery_list?.filter({ $0.status_tracking == "waiting delivery" || $0.status_tracking == "on delivery" || $0.status_tracking == "pending"})
                    
                    self?.pickupButton.isHidden = filterOrder?.count == 0
                    
                    if filterOrder?.count != 0 {
                        self?.display = .pickup
                    }
                    
                    if filterOrder?.count == 0 && filterOrderDelivery?.count != 0 {
                        self?.deliveryButton.isHidden = false
                        self?.display = .delivery
                    }else{
                        self?.deliveryButton.isHidden = true
                    }
                    
                    if filterOrder?.count == 0 && filterOrderDelivery?.count == 0 {
                        self?.constraint1.isActive = true
                        self?.constraint2.isActive = false
                    }else{
                        self?.constraint1.isActive = false
                        self?.constraint2.isActive = true
                    }
                    
                    self?.pickupList = order.pickup_list
                    self?.deliveryList = order.delivery_list
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = true
                    self?.labelEmpty.isHidden = true
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch display {
        case .pickup:
            if let orderData = pickupList {
                return orderData.count
            }
            return 0
        case .delivery:
            if let orderData = deliveryList {
                return orderData.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOrder = tableView.dequeueReusableCell(withIdentifier: OrderCell.id, for: indexPath) as! OrderCell
        
        let cellPending = tableView.dequeueReusableCell(withIdentifier: PendingCell.id, for: indexPath) as! PendingCell
        
        
        switch display {
        case .pickup:
            if let order = pickupList {
                cellOrder.pickupData = order[indexPath.row]
                cellPending.pickupData = order[indexPath.row]
                
                if activeShift != nil {
                    cellPending.shift = activeShift
                    cellOrder.shift = activeShift
                }
            }
            
            
            guard let orderData = pickupList else {
                return UITableViewCell()
            }
            
            let itemOrder = orderData[indexPath.row]
            
            if itemOrder.status_tracking == "pending" {
                return cellPending
            }else {
                return cellOrder
            }
            
        case .delivery:
            if let order = deliveryList {
                cellOrder.deliveryData = order[indexPath.row]
                cellPending.deliveryData = order[indexPath.row]
                
                if activeShift != nil {
                    cellPending.shift = activeShift
                    cellOrder.shift = activeShift
                }
            }
            
            
            guard let deliveryData = deliveryList else {
                return UITableViewCell()
            }
            
            let itemDelivery = deliveryData[indexPath.row]
            
            if itemDelivery.status_tracking == "pending" {
                return cellPending
            }else {
                return cellOrder
            }
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
 
        let rejectAction = UIContextualAction(
            style: .normal,
            title: "Decline".localiz(),
            handler: {[weak self](action, view, completion) in
                   completion(true)
                
                guard let dateOrder = self?.deliveryList,
                      let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                            let codeDriver = userData["codeDriver"] as? String,
                            let idGroup = userData["idGroup"] as? Int  else {return}
                
                let orderNo = dateOrder[indexPath.row].order_number
                
                let data: DeleteHistory = DeleteHistory(order_number: orderNo, code_driver: codeDriver, id_group: idGroup)
                if self!.totalReject >= 2 {
                    return
                }
                
                
                self?.orderViewModel.rejectOrder(data: data) {[weak self] (res) in
                    switch res {
                    case .failure(_):
                        Helpers().showAlert(view: self!, message: "Failed to decline this order !".localiz())
                    case .success(let oke):
                        if oke {
                            self?.deliveryList.remove(at: indexPath.row)
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


        let imageDelete = UIImage(named: "remove")
        let delete = imageDelete?.resizeImage(CGSize(width: 25, height: 25))
    
        rejectAction.image = delete
        rejectAction.backgroundColor = UIColor(named: "darkKasumi")

        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any], let statusDriver = userData["status"] as? String  else {return nil}
        let cekDecline = pickupList.filter({$0.status_tracking == "wait for pickup" || ($0.status_tracking == "pending" && $0.pending_by_system == true)})
        let actions = statusDriver == "freelance" && allowReject && cekDecline.count > 0 ? [rejectAction] : []
        
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let container = UIView()
        
        container.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.bottom(toAnchor: container.bottomAnchor, space: -5)
        finishButton.right(toAnchor: container.rightAnchor, space: -10)
        finishButton.height(30)
        finishButton.width(120)
        
        if activeShift != nil && activeShift.id_shift_time != 4 {
            return container
        }
        return nil
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


class DateHeaderHome: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(named: "labelColor")
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
