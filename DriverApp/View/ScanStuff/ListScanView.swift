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

class ListScanView: UIViewController {
    
    var store: PickupDestination!
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    var inOutVm = InOutViewModel()
    
    var isCheckin: Bool = false
    var origin: Origin?
    var pickupItems: [Scanned]!
    var extraItem: AnotherPickup?
    
    var done: Bool = false
    
    //MARK: - COMPONENTS
    
    
    //MARK: - LOADING
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    lazy var scanButton:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "iconScan")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Scan QR Code to Verify".localiz(), for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "orangeKasumi")
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold )
        b.centerTextAndImage(spacing: 10.0)
        b.addTarget(self, action: #selector(add), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    
    lazy var finishButton:UIButton = {
        let b = UIButton()
        b.setTitle("Finish".localiz(), for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "orangeKasumi")
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold )
        b.addTarget(self, action: #selector(cekSatatusCheckin), for: .touchUpInside)
        return b
    }()
    
    lazy var manualButotn:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "iconKeyboard")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Add  Code Manually".localiz(), for: .normal)
        b.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular )
        b.centerTextAndImage(spacing: 10.0)
        b.addTarget(self, action: #selector(addMaunal), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    
    @objc
    private func addMaunal(){
        let vc = InputCode()
        vc.orderNo = orderNo
        vc.list = store.pickup_item
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func add(){
        let vc = CameraScanView()
        vc.orderNo = orderNo
        vc.list = store.pickup_item
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func cekStatusDriver(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
//        spiner.show(in: view)
        
        inOutVm.cekStatusDriver(codeDriver: codeDriver) { (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
//                    self.spiner.dismiss()
                    if response.isCheckin == true {
                        self.isCheckin = true
                    }
                }
            case .failure(let err):
//                self.spiner.dismiss()
                print(err.localizedDescription)
                self.isCheckin = false
            }
        }
        
    }
    
    
    @objc private func cekSatatusCheckin(){
        if let extra = extraItem {
            let extraScan = extra.pickup_list?.compactMap({$0.pickup_item?.filter({$0.scan == nil}).count})
            let totalExtraScan = extraScan?.reduce(0, { x, y in
                x+y
            })
            if totalExtraScan != 0 {
                print("masih ada \(totalExtraScan ?? 0) item yang belum di scan")
                return
            }
        }
     
        let scanedData = store.pickup_item.filter({$0.scan == true})
        if scanedData.count != store.pickup_item.count {
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
        if let extra = extraItem {
            let extraScan = extra.pickup_list?.compactMap({$0.pickup_item?.filter({$0.scan == nil}).count})
            let totalExtraScan = extraScan?.reduce(0, { x, y in
                x+y
            })
            if totalExtraScan != 0 {
                return
            }
        }
     
        let scanedData = store.pickup_item.filter({$0.scan == true})
        if scanedData.count == store.pickup_item.count {
            let codes: [String] = scanedData.map({$0.qr_code_raw})
            let data: Scan = Scan(order_number: orderNo, qr_code_raw: codes)
            spiner.show(in: view)
            let myGroup = DispatchGroup()
            
            var datas = [Scan]()
            
            if let extra = extraItem {
                _ = extra.pickup_list?.map { e in
                    let codes: [String] = (e.pickup_item?.map({$0.qr_code_raw}))!
                    let exData: Scan = Scan(order_number: e.order_no, qr_code_raw: codes)
                    datas.append(exData)
                }
            }
            
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
            
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                self.navigationController?.popViewController(animated: true)
                self.spiner.dismiss()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.backgroundColor = .white
        tv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tv.register(UINib(nibName: "ScanCell", bundle: nil), forCellReuseIdentifier: ScanCell.id)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tv.showsVerticalScrollIndicator = false
        tv.sectionFooterHeight = 0
        return tv
    }()
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Delivery Order List".localiz()
        
        view.backgroundColor = .white
        
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
        let data = store.pickup_item.map({$0.qr_code_raw})
        
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
                        self?.setupButton()
                    }else {
                        self?.done = true
                        self?.setupButton()
                    }
                }
            case .failure(_):
                self?.spiner.dismiss()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupButton(){
        //        manualButotn.isHidden = done
        //        scanButton.isHidden = done
        //        finishButton.isHidden = !done
    }
    
    private func configureUi(){
        view.addSubview(tableView)
        view.addSubviews(views: finishButton)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: finishButton.topAnchor, right: view.rightAnchor,paddingBottom: 40)
        
        tableView.separatorStyle = .none
        
        //        manualButotn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        //        scanButton.anchor(left: view.leftAnchor, bottom: manualButotn.topAnchor, right: view.rightAnchor, paddingBottom: 10, paddingLeft: 16, paddingRight: 16, height: 45)
        finishButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
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
        if let row = self.store.pickup_item.firstIndex(where: {$0.qr_code_raw == code}) {
            store.pickup_item[row].scan = true
        }
        let filtered = store.pickup_item.filter({$0.scan == nil})
        if filtered.count > 0 {
            done = false
            setupButton()
        }else {
            done = true
            setupButton()
        }
        tableView.reloadData()
    }
    
    func updateListExtra(code: String, orderNo: String){
        if let row = self.extraItem?.pickup_list?.firstIndex(where: {$0.order_no == orderNo}) {
            let findRow = self.extraItem?.pickup_list![row].pickup_item?.firstIndex(where: {$0.qr_code_raw == code})
            self.extraItem?.pickup_list![row].pickup_item![findRow!].scan = true
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


extension ListScanView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let extra = extraItem {
            guard let pickupLits = extra.pickup_list else {
                return 0
            }
            return pickupLits.count+1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return store.pickup_item.count
        }else{
            if let extra = extraItem {
                guard let pickupLits = extra.pickup_list else {
                    return 0
                }
                return pickupLits[section-1].pickup_item!.count
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScanCell.id, for: indexPath) as! ScanCell
        if indexPath.section == 0 {
            cell.item = store.pickup_item[indexPath.row]
            return cell
        }else {
            if let extra = extraItem {
                guard let pickupLits = extra.pickup_list else {
                    return UITableViewCell()
                }
                let item = pickupLits[indexPath.section-1].pickup_item![indexPath.row]
                cell.item = item
                return cell
            }else{
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    class TitleHeader: UILabel {
        
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
        
        let label = TitleHeader()
        label.numberOfLines = 0
        
        let containerLabel = UIView()
        containerLabel.addSubview(label)
        
        label.anchor(top: containerLabel.topAnchor, left: containerLabel.leftAnchor, bottom: containerLabel.bottomAnchor, right: containerLabel.rightAnchor, paddingTop: 2, paddingBottom: 2, paddingLeft: 10, paddingRight: 10)
        
        
        if section == 0 {
            label.text = "Item for this order".localiz() + ": \(orderNo)"
            return containerLabel
        }else {
            if let extra = extraItem {
                guard let pickupLits = extra.pickup_list else {
                    return nil
                }
                label.text = "Extra pickup item for Order No" + ": \(pickupLits[section-1].order_no)"
                return containerLabel
            }else {
                return nil
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = CameraScanView()
            vc.orderNo = orderNo
            vc.codeQr = store.pickup_item[indexPath.row].qr_code_raw
            vc.extra = false
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }else {
            if let extra = extraItem {
                guard let pickupLits = extra.pickup_list else {
                    return
                }
                let vc = CameraScanView()
                vc.orderNo = pickupLits[indexPath.section-1].order_no
                vc.codeQr = pickupLits[indexPath.section-1].pickup_item![indexPath.row].qr_code_raw
                vc.extra = true
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
