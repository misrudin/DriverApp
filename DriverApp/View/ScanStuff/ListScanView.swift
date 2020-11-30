//
//  ListScanView.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit
import JGProgressHUD

class ListScanView: UIViewController {
    
    var store: PickupDestination!
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    
    var pickupItems: [Scanned]!
    
    var done: Bool = false
    
    //MARK: - COMPONENTS
    //MARK: - LOADING
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    lazy var scanButton:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "iconScan")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Scan QR Code to Verify", for: .normal)
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
        b.setTitle("Finish", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "orangeKasumi")
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold )
        b.addTarget(self, action: #selector(finish), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    
    lazy var manualButotn:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "iconKeyboard")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Add  Code Manually", for: .normal)
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func add(){
        print("Scan With Camera")
    }
    
    @objc
    private func finish(){
        navigationController?.popViewController(animated: true)
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
        title = "Delivery Order List"

        view.backgroundColor = .white
        
        configureUi()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cekStatusItems()
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
                    self?.pickupItems = result
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
        navigationController?.title = "Delivery Order List"
    }
    
}


extension ListScanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let d = pickupItems {
            return d.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScanCell.id, for: indexPath) as! ScanCell
        cell.item = pickupItems[indexPath.row]
        return cell
    }
    
    
}
