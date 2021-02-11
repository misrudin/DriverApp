//
//  ListScanView.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit
import JGProgressHUD
import AVFoundation
import LanguageManager_iOS

@available(iOS 13.0, *)
class ListScanView: UIViewController {
    
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    var inOutVm = InOutViewModel()
    
    var isCheckin: Bool = false
    var origin: Origin?
    var pickupItems: [Scanned]!
    var items: [PickupItem]!
    var isLast: Bool = false
    weak var delegate: PickupOrderVc!
    var databaseM = DatabaseManager()
    
    var bopisStatus: Bool! {
        didSet {
            if bopisStatus == true {
                finishButton.setTitle("BOPIS", for: .normal)
            }else {
                finishButton.setTitle("Finish", for: .normal)
            }
        }
    }
    var store: [String: Any]!
    var classification: String!
    
    var done: Bool = false
    
    //MARK: - COMPONENTS
    
    
    //MARK: - LOADING
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    lazy var finishButton:UIButton = {
        let b = UIButton()
        b.setTitle("Finish".localiz(), for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "grayKasumi2")
        b.layer.cornerRadius = 40/2
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold )
        b.addTarget(self, action: #selector(cekSatatusCheckin), for: .touchUpInside)
        b.isUserInteractionEnabled = false
        return b
    }()
    
    
    @objc
    private func addMaunal(){
        let vc = InputCode()
        vc.orderNo = orderNo
        vc.list = items
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func add(){
        let vc = CameraScanView()
        vc.orderNo = orderNo
        vc.list = items
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func cekStatusDriver(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        inOutVm.cekStatusDriver(codeDriver: codeDriver) { (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.isCheckin == true {
                        self.isCheckin = true
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.isCheckin = false
            }
        }
        
    }
    
    
    @objc private func cekSatatusCheckin(){
        let scanedData = items.filter({$0.scan == true})
        if scanedData.count != items.count {
            print("belum semua")
            return
        }

        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String, let lat = origin?.latitude, let long = origin?.longitude else {
            print("No user data")
            return
        }
        if self.isCheckin == false {
            print("belum cekin")
            spiner.show(in: view)
            self.inOutVm.checkinDriver(with: codeDriver, lat: String(lat), long: String(long)) { (res) in
                switch res {
                case .success(let oke):
                    DispatchQueue.main.async {
                        if oke == true {
                            self.finish()
                            self.isCheckin = true
                        }
                    }
                case .failure(let err):
                    print(err)
                    Helpers().showAlert(view: self, message: "Something when wrong !".localiz())
                }
            }
        }else {
            print("Sudah cekin")
            self.finish()
        }
    }
    
    private func finish(){
        let scanedData = items.filter({$0.scan == true})
        if scanedData.count == items.count {
            let codes: [String] = scanedData.map({$0.qr_code_raw})
            let data: Scan = Scan(order_number: orderNo, qr_code_raw: codes)
            spiner.show(in: view)
            let myGroup = DispatchGroup()
            
            var datas = [Scan]()
            
            datas.append(data)
            
            for i in datas {
                myGroup.enter()
                orderVm.changeStatusItems(data: i) {[weak self] (res) in
                    switch res {
                    case .success(_):
                        myGroup.leave()
                        print("Finished request \(i)")
                    case .failure(let err):
                        let action1 = UIAlertAction(title: "Try again".localiz(), style: .default, handler: nil)
                        Helpers().showAlert(view: self!, message: "Something when wrong !".localiz(), customAction1: action1)
                        print(err)
                        self?.spiner.dismiss()
                    }
                }
            }
            
//            if let bopis = UserDefaults.standard.value(forKey: "bopis") as? [[String: Any]] {
//                print(bopis)
//            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                if self.classification == "BOPIS" && self.bopisStatus == true {
                    self.doneDeliveryBopis()
                    self.doneDeliveryOrder()
                }else if self.bopisStatus == true {
                    self.doneDeliveryBopis(pickup: true)
                    self.saveDataStoreBopis()
                }else {
                    self.donePickupOrder()
                    if self.classification == "BOPIS" {
                        self.storeData()
                    }
                }
                self.spiner.dismiss()
            }
        }
    }
    
    private func saveDataStoreBopis(){
        UserDefaults.standard.setValue(store, forKey: "store_bopis")
    }
    
    private func storeData(){
        //get data bopis dari session
        guard let bopis = UserDefaults.standard.value(forKey: "bopis") as? [[String: Any]] else {
            return UserDefaults.standard.setValue([self.store], forKey: "bopis")
        }
        //append data baru
        var stores: [[String: Any]] = bopis
        stores.append(self.store)
        //store data baru
        UserDefaults.standard.setValue(stores, forKey: "bopis")
    }
    
    private func doneDeliveryBopis(pickup: Bool? = false){
        //get data bopis dari session
        if let bopis = UserDefaults.standard.value(forKey: "bopis") as? [[String: Any]] {
            var stores = [Pickup]()
            _ = bopis.map { storeSession in
                guard let pickup_store_name = storeSession["pickup_store_name"] as? String,
                      let storeAddress =  storeSession["store_address"] as? String,
                      let lat = storeSession["lat"] as? String,
                      let long = storeSession["long"] as? String,
                      let orderNo = storeSession["order_number"] as? String,
                      let status = storeSession["status_tracking"] as? String,
                      let activeDate = storeSession["active_date"] as? String,
                      let queue = storeSession["queue"] as? Int,
                      let distance =  storeSession["distance"] as? Double,
                      let pendingStatus = storeSession["pending_by_system"] as? Bool,
                      let idShiftTime = storeSession["id_shift_time"] as? Int,
                      let bopisStatus = storeSession["store_bopis_status"] as? Bool
                      else {
                    print("No data")
                    return
                }
                let newStore: Pickup = Pickup(pickup_store_name: pickup_store_name,
                                              store_address: storeAddress,
                                              lat: lat,
                                              long: long,
                                              pickup_item: nil,
                                              order_number: orderNo,
                                              classification: nil,
                                              status_tracking: status,
                                              active_date: activeDate,
                                              queue: queue,
                                              distance: distance,
                                              pending_by_system: pendingStatus,
                                              id_shift_time: idShiftTime, store_bopis_status: bopisStatus)
                stores.append(newStore)
            }
            
            if stores.count != 0 {
                spiner.show(in: view)
                let myGroup = DispatchGroup()
                for i in stores {
                    myGroup.enter()
                    let data = Delivery(status: "delivery", order_number: i.order_number, type: "done")
                    orderVm.statusOrder(data: data) { (result) in
                        switch result {
                        case .success(_):
                            myGroup.leave()
                            print("Finished request \(i.order_number)")
                        case .failure(let error):
                            myGroup.leave()
                            print("Failed request \(i.order_number), \(error)")
                        }
                    }
                }
                
                myGroup.notify(queue: .main) {
                    print("Finished all requests.")
                    UserDefaults.standard.removeObject(forKey: "bopis")
                    UserDefaults.standard.removeObject(forKey: "store_bopis")
                    if self.classification != "BOPIS" {
                        self.donePickupOrder()
                    }else {
                        self.navigationController?.popViewController(animated: true)
                        if self.isLast {
                            self.delegate.closePickupVc()
                        }else{
                            self.delegate.cekOrderWaiting()
                        }
                    }
                    self.spiner.dismiss()
                }
            }
            
            
        }else {
            if pickup == true {
//                donePickupOrder()
                storeData()
            }
        }
    }
    
    private func donePickupOrder(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        let data = Delivery(status: "pickup", order_number: orderNo, type: "done")
        orderVm.statusOrder(data: data) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.databaseM.removeCurrentOrder(orderNo: self.orderNo, codeDriver: codeDriver) { (res) in
                        print(res)
                    }
                    self.spiner.dismiss()
                    self.navigationController?.popViewController(animated: true)
                    if self.isLast {
                        self.delegate.closePickupVc()
                    }else{
                        self.delegate.cekOrderWaiting()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    let action1 = UIAlertAction(title: "Try again".localiz(), style: .default, handler: nil)
                    Helpers().showAlert(view: self, message: "", customTitle: error.localizedDescription, customAction1: action1)
                }
            }
        }
    }
    
    private func doneDeliveryOrder(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        let data = Delivery(status: "delivery", order_number: orderNo, type: "done")
        orderVm.statusOrder(data: data) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.databaseM.removeCurrentOrder(orderNo: self.orderNo, codeDriver: codeDriver) { (res) in
                        print(res)
                    }
                    self.spiner.dismiss()
                    self.navigationController?.popViewController(animated: true)
                    if self.isLast {
                        self.delegate.closePickupVc()
                    }else{
                        self.delegate.cekOrderWaiting()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    let action1 = UIAlertAction(title: "Try again".localiz(), style: .default, handler: nil)
                    Helpers().showAlert(view: self, message: "", customTitle: error.localizedDescription, customAction1: action1)
                }
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "whiteKasumi")
        tv.register(UINib(nibName: "ScanCell", bundle: nil), forCellReuseIdentifier: ScanCell.id)
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tv.showsVerticalScrollIndicator = false
        tv.sectionHeaderHeight = 0
        
        return tv
    }()
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Delivery Order List".localiz()
        
        view.backgroundColor = UIColor(named: "whiteKasumi")
        
        configureUi()
        configureNavigationBar()
        cekStatusItems()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cekStatusDriver()
        //        cekStatusItems()
    }
    
    
    //MARK: - FUNCTIONS
    private func cekStatusItems(){
        let data = items.map({$0.qr_code_raw})
        
        let dataTopost: Scan = Scan(order_number: orderNo, qr_code_raw: data)
        
        spiner.show(in: view)
        orderVm.cekStatusItems(data: dataTopost) {[weak self] (res) in
            switch res {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.spiner.dismiss()
                    self?.tableView.reloadData()
                    let filtered = result.filter({$0.scanned_status == 0})
                    if filtered.count > 0 {
                        self?.done = false
                    }else {
                        self?.done = true
                    }
                }
            case .failure(_):
                self?.spiner.dismiss()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureUi(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableView.separatorStyle = .none
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.title = "Delivery Order List".localiz()
    }
    
    func updateList(code: String){
        if let row = self.items.firstIndex(where: {$0.qr_code_raw == code}) {
            items[row].scan = true
        }
        let filtered = items.filter({$0.scan == nil})
        if filtered.count > 0 {
            done = false
            finishButton.isUserInteractionEnabled = false
            finishButton.backgroundColor = UIColor(named: "grayKasumi2")
        }else {
            done = true
            finishButton.isUserInteractionEnabled = true
            finishButton.backgroundColor = UIColor(named: "orangeKasumi")
        }
        tableView.reloadData()
    }
    
    
    func useManualInput(orderNo: String, codeQr: String, extra: Bool){
        let vc = InputCode()
        vc.orderNo = orderNo
        vc.codeQr = codeQr
        vc.extra = extra
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


@available(iOS 13.0, *)
extension ListScanView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScanCell.id, for: indexPath) as! ScanCell
        cell.item = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CameraScanView()
        vc.orderNo = orderNo
        vc.codeQr = items[indexPath.row].qr_code_raw
        vc.extra = false
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let container = UIView()
        
        container.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.bottom(toAnchor: container.bottomAnchor, space: -5)
        finishButton.left(toAnchor: container.leftAnchor, space: 10)
        finishButton.right(toAnchor: container.rightAnchor, space: -10)
        finishButton.height(40)
        
        return container
    }
    
}
