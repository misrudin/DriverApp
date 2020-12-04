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

@available(iOS 13.0, *)
class HomeVc: UIViewController {
    
    private var manager: CLLocationManager?
    private var driverManager: CLLocationManager?
    
    var inOutVm = InOutViewModel()
    var origin: Origin? = nil
    
    var noteVm = NoteViewModel()
    var pendingNotes: [Note]!
    
    var allowReject: Bool = false
    
    var expanded: Bool = false
    
    var databaseManager = DatabaseManager()
    
    var profileVm = ProfileViewModel()
    
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
    
    
    var orderViewModel = OrderViewModel()
    var orderData: [OrderListDate]?
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: OrderCell.id)
        table.register(UINib(nibName: "PendingCell", bundle: nil), forCellReuseIdentifier: PendingCell.id)
        table.backgroundColor = UIColor(named: "grayKasumi")
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
        
        view.backgroundColor = UIColor(named: "grayKasumi")
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getDataOrder), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        view.addSubview(emptyImage)
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
                print("---Sudah beda hari--")
                let data: [String: Any] = [
                    "code_driver": codeDriver,
                    "date": dateString
                ]
                UserDefaults.standard.setValue(data, forKey: "userSession")
                getCurrentPosition()
            }else {
                print("---Masih di hari yang sama---")
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
                    print("----Driver lain Login---")
                }else {
                    getDataOrder()
                    print("----Masih Driver Yang Sama---")
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
        
        //get pending note
        getPendingNote()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyImage.dropShadow(color: UIColor(named: "orangeKasumi")!, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 120/2, scale: true)
    }
    
    
    private func getPendingNote(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        noteVm.getDataNotePending(codeDriver: codeDriver) { (res) in
            switch res {
            case .failure(let error): print(error)
            case .success(let notes):
                DispatchQueue.main.async {
                    self.pendingNotes = notes
                    self.tableView.reloadData()
                }
            }
        }
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
        emptyImage.isHidden = true
        // get data from api
        
        orderViewModel.getDataOrder(codeDriver: codeDriver) {[weak self] (res) in
            switch res {
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self?.orderData = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = false
                }
            case .success(let order):
                DispatchQueue.main.async {
                    self?.orderData = order
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = true
                }
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
        
        navigationItem.title = "Job List"
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
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}



//MARK: - TABLE VIEW ORDER
@available(iOS 13.0, *)
extension HomeVc: UITableViewDelegate,UITableViewDataSource {
    @objc func colapsibleHeaderPending(){
        var indexPaths = [IndexPath]()
        for row in pendingNotes.indices {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
        }
        
        expanded = !expanded
        
        
        if !expanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.arrowRight.transform = .identity
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.arrowRight.rotate(angle: 90)
            })
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let orderData = orderData {
            return orderData.count+1
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
           let v = UIView()
            v.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1)
            v.backgroundColor = UIColor(named: "orangeKasumi")
           return v
        }
        return nil
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let pending = pendingNotes {
                if expanded {
                    return pending.count
                }else {
                    return 0
                }
            }else {
                return 0
            }
        }else {
            if let orderData = orderData {
                if orderData[section-1].order_list != nil {
                    return orderData[section-1].order_list!.filter({$0.status_tracking != "pending"}).count
    //                return orderData[section].order_list!.count
                }else {
                    return 0
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PendingCell.id, for: indexPath) as! PendingCell
            if let pending = pendingNotes {
                cell.pendingData = pending[indexPath.row]
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.id, for: indexPath) as! OrderCell
            
            if let order = orderData {
                let data = order[indexPath.section-1].order_list?.filter({$0.status_tracking != "pending" })
                if data != nil {
                    //                cell.orderData = order[indexPath.section].order_list![indexPath.row]
                    cell.orderData = data![indexPath.row]
                }
            }
            
            
            return cell
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
        
        label.anchor(top: containerLabel.topAnchor, left: containerLabel.leftAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 2, paddingBottom: 2, paddingLeft: 16, paddingRight: 16)
        

        if section == 0 {
            if let pending = pendingNotes {
                label.text = "Pending Delivery (\(pending.count))"
            }else {
                label.text = "Pending Delivery (0)"
            }
            containerLabel.addSubview(arrowRight)
            
            
            arrowRight.anchor(top: containerLabel.topAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingRight: 16, width: 20)
            
            containerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colapsibleHeaderPending)))
            return containerLabel
        }else {
            if let order = orderData {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy/MM/dd"
                let date = dateFormater.date(from: order[section-1].date)
                let dateString = dateFormater.string(from: date!)
                
                let dateStringNow = dateFormater.string(from: Date())
                
                let value = dateString == dateStringNow ? "Today" : dateString
                
                let totalOrderList = order[section-1].order_list?.filter({$0.status_tracking != "pending"})
                
                label.text = "\(value) (\(totalOrderList?.count ?? 0))"
                
                
                return containerLabel
            }
        }
  
        return nil
               
       }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            print("pending Data")
        }else {
            if let orderData = orderData {
                let order = orderData[indexPath.section-1].order_list![indexPath.row]
                
                let vc = LiveTrackingVC()
                vc.order = order
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
 
        let rejectAction = UIContextualAction(
            style: .normal,
               title: "Decline",
            handler: {[weak self](action, view, completion) in
                   completion(true)
                
                guard let allorder = self?.orderData,
                      let dateOrder = allorder[indexPath.section-1].order_list,
                      let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                            let codeDriver = userData["codeDriver"] as? String  else {return}
                
                let orderNo = dateOrder[indexPath.row].order_number
                
                let data: DeleteHistory = DeleteHistory(order_number: orderNo, code_driver: codeDriver)
                
                self?.orderViewModel.rejectOrder(data: data) { (res) in
                    switch res {
                    case .failure(let err):
                        print(err)
                        self?.tableView.reloadData()
                    case .success(let oke):
                        DispatchQueue.main.async {
                            print(oke)
                            self?.tableView.reloadData()
                        }
                    }
             
                }
                
           })
        
        let pendingAction = UIContextualAction(
            style: .normal,
               title: "Pending",
            handler: {[weak self](action, view, completion) in
                   completion(true)
                let vc = PendingNoteVc()
                if let order = self?.orderData {
                    if order[indexPath.section-1].order_list != nil {
                        let orderList = order[indexPath.section-1].order_list
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
        pendingAction.backgroundColor = UIColor(named: "darkKasumi")
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                    let statusDriver = userData["status"] as? String  else {return nil}
        let actions = statusDriver == "frelance" && allowReject ? [rejectAction, pendingAction] : [pendingAction]
        
        
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
            print(manager)
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String,
                  let idDriver = userData["idDriver"] as? Int else {
                return
            }
            databaseManager.updateData(idDriver: String(idDriver), codeDriver: codeDriver, lat: coordinate.latitude, lng: coordinate.longitude, status: "idle",bearing: location.course) {[weak self] (res) in
                switch res {
                case .failure(let err):
                    print(err)
                case .success(let oke):
                    if oke {
                        print("succes update location to firebase")
                        self?.driverManager?.stopUpdatingLocation()
                    }
                }
            }
            manager.stopUpdatingLocation()
        }
    }
    
}
