//
//  HistoryViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import JGProgressHUD

class HistoryViewController: UIViewController {
    
    private let emptyImage: UIView = {
        let view = UIView()
        let imageView: UIImageView = {
           let img = UIImageView()
            img.image = UIImage(systemName: "mail.and.text.magnifyingglass")
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
    
    var orderData: [History]?
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    lazy var refreshControl = UIRefreshControl()

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.id)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame=view.bounds
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getDataOrder), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        view.addSubview(emptyImage)
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyImage.dropShadow(color: UIColor(named: "orangeKasumi")!, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 120/2, scale: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataOrder()
    }
    
    @objc
    func getDataOrder(){
        // get data detail user from local
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        // get data from api
        
        getHistory(codeDriver: codeDriver)
    }
    
    func getHistory(codeDriver: String){
        spiner.show(in: view)
        emptyImage.isHidden = true
        OrderViewModel().getDataHistoryOrder(codeDriver: codeDriver) {[weak self] (result) in
            switch result {
            case .success(let order):
                DispatchQueue.main.async {
                    self?.orderData = order.data
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = true
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.orderData = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = false
                }
            }
        }
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Jobs History"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipses.bubble.fill"), style: .plain, target: self, action: #selector(onClickChatButton))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HistoryViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderData = orderData {
            return orderData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.id, for: indexPath) as! OrderTableViewCell
        
        if let orderData = orderData {
            cell.labelOrder.text = "Order Number: \(orderData[indexPath.row].orderNumber)"
            cell.labelAdresDetail.text = "\(orderData[indexPath.row].addressUser)"
        }
        
        return cell
    }
}
