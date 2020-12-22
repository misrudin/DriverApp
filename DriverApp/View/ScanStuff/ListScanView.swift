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
        b.isHidden = true
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
        spiner.show(in: view)
        
        inOutVm.cekStatusDriver(codeDriver: codeDriver) { (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    if response.isCheckin == true {
                        self.isCheckin = true
                    }
                }
            case .failure(let err):
                self.spiner.dismiss()
                print(err.localizedDescription)
                self.isCheckin = false
            }
        }
        
    }
    
    
    @objc private func cekSatatusCheckin(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String, let lat = origin?.latitude, let long = origin?.longitude else {
            print("No user data")
            return
        }
        if self.isCheckin == false {
            print("belum cekin")
            self.inOutVm.checkinDriver(with: codeDriver, lat: String(lat), long: String(long)) { (res) in
                switch res {
                case .success(let oke):
                    DispatchQueue.main.async {
                        if oke == true {
                            self.finish()
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
        let scanedData = store.pickup_item.filter({$0.scan == true})
        if scanedData.count == store.pickup_item.count {
            let codes: [String] = scanedData.map({$0.qr_code_raw})
            let data: Scan = Scan(order_number: orderNo, qr_code_raw: codes)
            spiner.show(in: view)
            orderVm.changeStatusItems(data: data) {[weak self] (res) in
                switch res {
                case .success(let oke):
                    DispatchQueue.main.async {
                        if oke == true {
                            self?.navigationController?.popViewController(animated: true)
                        }
                        self?.spiner.dismiss()
                    }
                case .failure(let err):
                    let action1 = UIAlertAction(title: "Try again".localiz(), style: .default, handler: nil)
                    Helpers().showAlert(view: self!, message: "Something when wrong !".localiz(), customAction1: action1)
                    print(err)
                    self?.spiner.dismiss()
                }
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tv.register(UINib(nibName: "ScanCell", bundle: nil), forCellReuseIdentifier: ScanCell.id)
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
//                    self?.pickupItems = result
//                    print(result)
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
        manualButotn.isHidden = done
        scanButton.isHidden = done
        finishButton.isHidden = !done
    }
    
    private func configureUi(){
        view.addSubview(tableView)
        view.addSubviews(views: scanButton, manualButotn,finishButton)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: scanButton.topAnchor, right: view.rightAnchor,paddingBottom: 40)
        
        tableView.separatorStyle = .none
        
        manualButotn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        scanButton.anchor(left: view.leftAnchor, bottom: manualButotn.topAnchor, right: view.rightAnchor, paddingBottom: 10, paddingLeft: 16, paddingRight: 16, height: 45)
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
    
}


extension ListScanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return store.pickup_item.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScanCell.id, for: indexPath) as! ScanCell
        cell.item = store.pickup_item[indexPath.row]
        return cell
    }
    
    
}
