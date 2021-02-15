//
//  NextShiftVc.swift
//  DriverApp
//
//  Created by Indo Office4 on 15/02/21.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD
import CoreLocation
import LanguageManager_iOS

@available(iOS 13.0, *)
class NextShiftVc: UIViewController {
    
    private var manager: CLLocationManager?
    private var driverManager: CLLocationManager?
    
    var inOutVm = InOutViewModel()
    var origin: Origin? = nil
    
    var databaseManager = DatabaseManager()
    
    var profileVm = ProfileViewModel()
    
    var shiftTimeVm = ShiftTimeViewModel()
    var activeShift: ShiftTime!
    
    var pickupList: [Pickup]!
    var deliveryList: [NewDelivery]!
    
    var homeTable = [DataTable]()
    
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
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = 0
        return table
    }()
    
    let labelTitle = Reusable.makeLabel(text: "DELIVERY LIST ORDER".localiz(), font: .systemFont(ofSize: 15, weight: .medium), color: UIColor(named: "orangeKasumi")!, numberOfLines: 0, alignment: .left)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "whiteKasumi")
        
        view.addSubview(tableView)
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
        
        tableView.anchor(top: labelTitle.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelEmpty.anchor(top: emptyImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        labelEmpty.isHidden = true
        
        
    }
    
    @objc private func getListShiftTime(){
        spiner.show(in: view)
        homeTable = []
        shiftTimeVm.getCurrentShiftTime {[weak self] (res) in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.activeShift = data
                    self?.getAllShiftTime()
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
            }
        }
    }
    
    @objc private func getAllShiftTime(){
        shiftTimeVm.getAllShiftTime {[weak self] (res) in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    let filteredShift = data.filter({$0.time_start_shift >= (self?.activeShift.time_end_shift)!})
                    
                    var temporaryData = [DataTable]()
                    let myGrup = DispatchGroup()
                    
                    _ = filteredShift.map { shift in
                        myGrup.enter()
                        self?.getDataOrder(shift: shift) {order in
                            let isOpen = true
                            let sortedPickup = order?.pickup_list!.sorted(by: {$0.queue < $1.queue})
                            let sortedDelivery = order?.delivery_list!.sorted(by: {$0.queue < $1.queue})
                            let orderData = NewDataOrder(pickup_list: sortedPickup, delivery_list: sortedDelivery)
                            temporaryData.append(DataTable(isOpen: isOpen, data: orderData, shift: shift))
                            myGrup.leave()
                        }
                    }
                    
                    myGrup.notify(queue: .main) {
                        let sortedTemporary = temporaryData.sorted {
                            $0.shift.time_end_shift <= $1.shift.time_start_shift
                        }
                        self?.homeTable = sortedTemporary
                        self?.spiner.dismiss()
                        self?.refreshControl.endRefreshing()
                        self?.emptyImage.isHidden = true
                        self?.labelEmpty.isHidden = true
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.spiner.dismiss()
                self?.refreshControl.endRefreshing()
                self?.emptyImage.isHidden = false
                self?.labelEmpty.isHidden = false
                self?.labelEmpty.text = error.localizedDescription
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
    
    private func getDataOrder(shift: ShiftTime, completion: @escaping (_ order: NewDataOrder?) -> Void){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        orderViewModel.getDataOrder(codeDriver: codeDriver, shift: shift.id_shift_time) {(res) in
            switch res {
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .success(let order):
                DispatchQueue.main.async {
                    completion(order)
                }
            }
        }
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Next Shift".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
}



//MARK: - TABLE VIEW ORDER
@available(iOS 13.0, *)
extension NextShiftVc: UITableViewDelegate,UITableViewDataSource {
    @objc func colapsibleHeaderPending(sender: CustomColapse){
        let section = sender.section
        homeTable[section!].isOpen = !homeTable[section!].isOpen
        switch display {
        case .pickup:
            if homeTable[section!].data.pickup_list != nil {
                var indexPaths = [IndexPath]()
                for row in homeTable[section!].data.pickup_list!.indices {
                    let indexPath = IndexPath(row: row, section: section!)
                    indexPaths.append(indexPath)
                }
                if !homeTable[section!].isOpen {
                    tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    tableView.insertRows(at: indexPaths, with: .fade)
                }
            }
        default:
            if homeTable[section!].data.delivery_list != nil {
                var indexPaths = [IndexPath]()
                for row in homeTable[section!].data.delivery_list!.indices {
                    let indexPath = IndexPath(row: row, section: section!)
                    indexPaths.append(indexPath)
                }
                if !homeTable[section!].isOpen {
                    tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    tableView.insertRows(at: indexPaths, with: .fade)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTable.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeTable.count != 0 {
            switch display {
            case .pickup:
                let orderData = homeTable[section]
                if orderData.isOpen {
                    if orderData.data.pickup_list != nil {
                        return orderData.data.pickup_list!.count
                    }
                }
                return 0
            case .delivery:
                let orderData = homeTable[section]
                if orderData.isOpen {
                    if orderData.data.delivery_list != nil {
                        return orderData.data.delivery_list!.count
                    }
                }
                return 0
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOrder = tableView.dequeueReusableCell(withIdentifier: OrderCell.id, for: indexPath) as! OrderCell
        
        let cellPending = tableView.dequeueReusableCell(withIdentifier: PendingCell.id, for: indexPath) as! PendingCell
        
        
        if homeTable.count != 0 {
            switch display {
            case .pickup:
                if let order = homeTable[indexPath.section].data.pickup_list {
                    cellOrder.pickupData = order[indexPath.row]
                    cellPending.pickupData = order[indexPath.row]
                    
                    cellPending.shift = homeTable[indexPath.section].shift
                    cellOrder.shift = homeTable[indexPath.section].shift
                }
                
                
                guard let orderData = homeTable[indexPath.section].data.pickup_list else {
                    return UITableViewCell()
                }
                
                let itemOrder = orderData[indexPath.row]
                
                if itemOrder.status_tracking == "pending" {
                    return cellPending
                }else {
                    return cellOrder
                }
                
            case .delivery:
                if let order = homeTable[indexPath.section].data.delivery_list {
                    cellOrder.deliveryData = order[indexPath.row]
                    cellPending.deliveryData = order[indexPath.row]
                    
                    cellPending.shift = homeTable[indexPath.section].shift
                    cellOrder.shift = homeTable[indexPath.section].shift
                }
                
                
                guard let deliveryData = homeTable[indexPath.section].data.delivery_list else {
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
        }else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if homeTable.count != 0 {
            let label = DateHeaderHome()
            
            let arrowRight: UIImageView = {
                let img = UIImageView()
                let imageAset = UIImage(named: "arrowRight")
                let baru = imageAset?.resizeImage(CGSize(width: 20, height: 20))
                img.image = baru
                img.layer.masksToBounds = true
                img.contentMode = .right
                return img
            }()
            
            
            let containerLabel = UIView()
            containerLabel.addSubview(label)
            
            label.anchor(top: containerLabel.topAnchor, left: containerLabel.leftAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 2, paddingBottom: 2, paddingLeft: 16, paddingRight: 16)
            
            label.text = homeTable[section].shift.label_data
            
            containerLabel.addSubview(arrowRight)
            
            arrowRight.anchor(top: containerLabel.topAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingRight: 16, width: 20)
            
            if homeTable[section].isOpen {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    arrowRight.rotate(angle: 90)
                })
            }else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    arrowRight.transform = .identity
                })
            }
            
            let gestture = CustomColapse(target: self, action: #selector(colapsibleHeaderPending))
            gestture.section = section
            containerLabel.addGestureRecognizer(gestture)
            return containerLabel
        }
        return nil
    }
    
}


@available(iOS 13.0, *)
extension NextShiftVc: CLLocationManagerDelegate {
    
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

class CustomColapse: UITapGestureRecognizer {
    var section: Int!
}
