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

struct DoScan: Decodable {
    let order_number: String
    let data_scan: Scan
}

struct DoneScan: Decodable {
    let order_number: String
    let data_scan: ScanedData
}

@available(iOS 13.0, *)
class ListScanView: UIViewController {
    
    var orderVm = OrderViewModel()
    var inOutVm = InOutViewModel()
    var allPickupList = [Pickup]()
    var pickupList = [Pickup]()
    var storeName: String! {
        didSet {
            storeNameLabel.text = storeName
        }
    }
    
    var isCheckin: Bool = false
    var origin: Origin?
    var pickupItems: [Scanned]!
    var isLast: Bool = false
    weak var delegate: PickupOrderVc!
    var databaseM = DatabaseManager()
    
    var done: Bool = false
     
    var itemHasScan = [DoneScan]()
    
    //MARK: - COMPONENTS
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = UIColor(named: "labelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        let filtered = pickupList.compactMap { pickup in
            return pickup.pickup_item?.filter({$0.scan == nil})
        }
        let flatFiltered = filtered.flatMap({$0})
        
        if flatFiltered.count != 0 {
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
        spiner.show(in: view)
        let myGroup = DispatchGroup()
        
        var datas = [Scan]()
        
        _ = pickupList.map {  pickup in
            let codes = pickup.pickup_item?.map({$0.qr_code_url})
            let scan = Scan(order_number: pickup.order_number, qr_code_url: codes!)
            datas.append(scan)
        }
        
        for i in datas {
            myGroup.enter()
            orderVm.changeStatusItems(data: i) {[weak self] (res) in
                switch res {
                case .success(_):
                    DispatchQueue.main.async {
                        myGroup.leave()
                        print("Finished request \(i)")
                    }
                case .failure(let err):
                    let action1 = UIAlertAction(title: "Try again".localiz(), style: .default, handler: nil)
                    Helpers().showAlert(view: self!, message: "Something when wrong !".localiz(), customAction1: action1)
                    print(err)
                    self?.spiner.dismiss()
                }
            }
        }

        //  loop pickupList and fillter all pickup list
        
        //  bopis & drop
        //  if filter result.cout > 1  ? store data bopis & data store drop - continue else done delivery
        
        //  bopis & !drop
        //  simpan data bopis dan lanjutkan
        
        //  !bopis & drop
        //  done pickup dan simpan data store drop
        
        //  !bopis & !drop
        //  done pickup dan lanjutkan
        
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            
            _ = self.pickupList.map { pickup in
                let filter = self.allPickupList.filter({$0.order_number == pickup.order_number})
                
                if filter.count <= 1 {
                    if pickup.classification != "BOPIS" && !pickup.store_bopis_status! {
                        self.donePickupOrder(orderNo: pickup.order_number)
                    }
                    
                    if pickup.classification == "BOPIS" && !pickup.store_bopis_status! {
                        self.storeData(store: pickup.dictionary)
                    }
                    
                    if pickup.classification != "BOPIS" && pickup.store_bopis_status! {
                        self.saveDataStoreBopis(store: pickup.dictionary)
                        self.donePickupOrder(orderNo: pickup.order_number)
                    }
                    
                    if pickup.classification == "BOPIS" && pickup.store_bopis_status! {
                        self.saveDataStoreBopis(store: pickup.dictionary)
                        self.doneDeliveryBopis()
                        self.doneDeliveryOrder(orderNo: pickup.order_number)
                    }
                }else {
                    if pickup.classification != "BOPIS" && !pickup.store_bopis_status! {
                        self.skipingData(store: pickup.dictionary)
                    }
                    
                    if pickup.classification == "BOPIS" && !pickup.store_bopis_status! {
                        let filterClass = filter.filter({$0.classification == "BOPIS"})
                        if filterClass.count > 1 {
                            self.storeData(store: pickup.dictionary)
                        }else {
                            self.skipBopisData(store: pickup.dictionary)
                        }
                    }
                    
                    if pickup.classification != "BOPIS" && pickup.store_bopis_status! {
                        self.saveDataStoreBopis(store: pickup.dictionary)
                        self.skipingData(store: pickup.dictionary)
                    }
                    
                    if pickup.classification == "BOPIS" && pickup.store_bopis_status! {
                        let filterClass = filter.filter({$0.classification == "BOPIS" && $0.pickup_store_status == true})
                        if filterClass.count > 1 {
                            self.doneDeliveryBopis()
                            self.doneDeliveryOrder(orderNo: pickup.order_number)
                        }else {
                            self.skipBopisData(store: pickup.dictionary)
                        }
                        self.saveDataStoreBopis(store: pickup.dictionary)
                    }
                }
            }
            self.spiner.dismiss()
            self.delegate.cekOrderWaiting()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveScanWehnBack(){
        var datas = [Scan]()
        
        _ = pickupList.map {  pickup in
            let scaned = pickup.pickup_item!.filter({$0.scan != nil})
            if scaned.count != 0 {
                let codes = scaned.map({$0.qr_code_url})
                let scan = Scan(order_number: pickup.order_number, qr_code_url: codes)
                datas.append(scan)
            }
        }
        
        if datas.count != 0 {
            spiner.show(in: view)
            let myGroup = DispatchGroup()
            for i in datas {
                myGroup.enter()
                orderVm.changeStatusItems(data: i) {[weak self] (res) in
                    switch res {
                    case .success(_):
                        DispatchQueue.main.async {
                            myGroup.leave()
                            print("Finished request \(i)")
                        }
                    case .failure(let err):
                        let action1 = UIAlertAction(title: "Try again".localiz(), style: .default, handler: nil)
                        Helpers().showAlert(view: self!, message: "Something when wrong !".localiz(), customAction1: action1)
                        print(err)
                        self?.spiner.dismiss()
                    }
                }
            }
            
            myGroup.notify(queue: .main) {
                self.spiner.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }else  {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveDataStoreBopis(store: [String: Any]){
        UserDefaults.standard.setValue(store, forKey: "store_bopis")
    }
    
    private func storeData(store: [String: Any]){
        //get data bopis dari session
        guard let bopis = UserDefaults.standard.value(forKey: "bopis") as? [[String: Any]] else {
            return UserDefaults.standard.setValue([store], forKey: "bopis")
        }
        //append data baru
        var stores: [[String: Any]] = bopis
        stores.append(store)
        //store data baru
        UserDefaults.standard.setValue(stores, forKey: "bopis")
    }
    
    private func skipBopisData(store: [String: Any]){
        //get data bopis dari session
        guard let bopis = UserDefaults.standard.value(forKey: "bopis_skip") as? [[String: Any]] else {
            return UserDefaults.standard.setValue([store], forKey: "bopis_skip")
        }
        //append data baru
        var stores: [[String: Any]] = bopis
        stores.append(store)
        //store data baru
        UserDefaults.standard.setValue(stores, forKey: "bopis_skip")
    }
    
    private func skipingData(store: [String: Any]){
        //get data bopis dari session
        guard let skip = UserDefaults.standard.value(forKey: "skip") as? [[String: Any]] else {
            return UserDefaults.standard.setValue([store], forKey: "skip")
        }
        //append data baru
        var skips: [[String: Any]] = skip
        skips.append(store)
        //store data baru
        UserDefaults.standard.setValue(skips, forKey: "skip")
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
                                              id_shift_time: idShiftTime,
                                              store_bopis_status: bopisStatus,
                                              pickup_store_status: true)
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
                    self.spiner.dismiss()
                }
            }
        }
    }
    
    private func donePickupOrder(orderNo: String){
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
                    self.databaseM.removeCurrentOrder(orderNo: orderNo, codeDriver: codeDriver) { (res) in
                        print(res)
                    }
                    self.spiner.dismiss()
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
    
    private func doneDeliveryOrder(orderNo: String){
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
                    self.databaseM.removeCurrentOrder(orderNo: orderNo, codeDriver: codeDriver) { (res) in
                        print(res)
                    }
                    self.spiner.dismiss()
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
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.backgroundColor = UIColor(named: "whiteKasumi")
        tv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tv.register(UINib(nibName: "ScanCell", bundle: nil), forCellReuseIdentifier: ScanCell.id)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tv.showsVerticalScrollIndicator = false
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
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc
    private func back(sender: UIBarButtonItem){
        let action1 = UIAlertAction(title: "Back".localiz(), style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let action2 = UIAlertAction(title: "Cancel".localiz(), style: .default, handler: nil)

        let filtered = pickupList.compactMap { pickup in
            return pickup.pickup_item?.filter({$0.scan != nil})
        }

        let flatFiltered = filtered.flatMap({$0})

        if flatFiltered.count == 0 {
            navigationController?.popViewController(animated: true)
        }else {
            let title = "Please confirm"
            let message = "if you go back, then you have to scan again!"
            Helpers().showAlert(view: self, message: message, customTitle: title, customAction1: action2, customAction2: action1)
        }
//        saveScanWehnBack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cekStatusDriver()
    }
    
    
    //MARK: - FUNCTIONS
    private func cekStatusItems(){
        var dataToScan = [Scan]()
        
        _ = pickupList.map({ pickup in
            let qrs = pickup.pickup_item!.map({$0.qr_code_url})
            dataToScan.append(Scan(order_number: pickup.order_number, qr_code_url: qrs))
        })
        
        if dataToScan.count != 0 {
            spiner.show(in: view)
            let myGroup = DispatchGroup()
            
            for i in dataToScan {
                myGroup.enter()
                orderVm.cekStatusItems(data: i) {[weak self] (res) in
                    switch res {
                    case .success(let result):
                        DispatchQueue.main.async {
                            _ = result.map({ r in
                                if r.scanned_status > 0 {
                                    self?.updateList(code: r.qr_code_url, orderNo: r.order_number)
                                }
                            })
                            myGroup.leave()
                        }
                    case .failure(_):
                        myGroup.leave()
                    }
                }
            }
            
            myGroup.notify(queue: .main) {
                self.spiner.dismiss()
            }
        }
    }
    
    private func configureUi(){
        view.addSubview(tableView)
        view.addSubview(storeNameLabel)
        
        storeNameLabel.top(toAnchor: view.safeAreaLayoutGuide.topAnchor, space: 10)
        storeNameLabel.left(toAnchor: view.leftAnchor, space: 10)
        storeNameLabel.right(toAnchor: view.rightAnchor, space: 10)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: storeNameLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
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
    
    func updateList(code: String, orderNo: String){
        if let rowOrder = pickupList.firstIndex(where: {$0.order_number == orderNo}) {
            if let row = pickupList[rowOrder].pickup_item!.firstIndex(where: {$0.qr_code_url == code && $0.scan == nil}) {
                pickupList[rowOrder].pickup_item![row].scan = true
            }
        }
        
        let filtered = pickupList.compactMap { pickup in
            return pickup.pickup_item?.filter({$0.scan == nil})
        }
        let flatFiltered = filtered.flatMap({$0})
        if flatFiltered.count > 0 {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        print(pickupList)
        return pickupList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickupList[section].pickup_item!.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScanCell.id, for: indexPath) as! ScanCell
        cell.item = pickupList[indexPath.section].pickup_item![indexPath.row]
        cell.clas = pickupList[indexPath.section].classification
        cell.isBopis = pickupList[indexPath.section].store_bopis_status
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CameraScanView()
        vc.orderNo = pickupList[indexPath.section].order_number
        vc.codeQr = pickupList[indexPath.section].pickup_item![indexPath.row].qr_code_url
        vc.extra = false
        vc.delegate = self
        if pickupList[indexPath.section].pickup_item![indexPath.row].scan == nil {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == pickupList.count - 1 {
            return 80
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if pickupList.count != 0 {
            let label = DateHeaderHome()
            
            let containerLabel = UIView()
            containerLabel.addSubview(label)
            
            label.anchor(top: containerLabel.topAnchor, left: containerLabel.leftAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 2, paddingBottom: 2, paddingLeft: 10, paddingRight: 10)
            
            label.text = "Order No : \(pickupList[section].order_number)"
            
            return containerLabel
        }
        return nil
    }
    
}
