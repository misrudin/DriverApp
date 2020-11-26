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
    
    var inOutVm = InOutViewModel()
    var origin: Origin? = nil
    
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
    var orderData: [NewOrderData]?
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: OrderCell.id)
        table.backgroundColor = UIColor(named: "grayKasumi")
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
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
                print("!==")
                let data: [String: Any] = [
                    "code_driver": codeDriver,
                    "date": dateString
                ]
                UserDefaults.standard.setValue(data, forKey: "userSession")
                getCurrentPosition()
            }else {
                print("==")
                getDataOrder()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyImage.dropShadow(color: UIColor(named: "orangeKasumi")!, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 120/2, scale: true)
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
                print(err.localizedDescription)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderData = orderData {
            return orderData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.id, for: indexPath) as! OrderCell
        
        if let order = orderData {
            cell.orderData = order[indexPath.row]
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let orderData = orderData {
            let order = orderData[indexPath.row]
            
            let vc = LiveTrackingVC()
            vc.order = order
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}


@available(iOS 13.0, *)
extension HomeVc: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            self.origin = Origin(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.upateLocation()
            manager.stopUpdatingLocation()
        }
    }
}
