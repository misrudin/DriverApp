//
//  HomeVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVc: UIViewController {
    
     let pop = PopUpView()
    
    var orderViewModel = OrderViewModel()
    var orderData: [Order]?
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.id)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        orderViewModel.delegate = self
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
        view.addSubview(pop)
        pop.show = true
        // get data from api
        
        orderViewModel.getDataOrder(codeDriver: codeDriver)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Jobs Detail"
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
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
    }
}


extension HomeVc: UITableViewDelegate,UITableViewDataSource {
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // munculkan halaman maps untuk live tracking wkwkw edan bos
        tableView.deselectRow(at: indexPath, animated: true)
        if let orderData = orderData {
            let order = orderData[indexPath.row]
            
            let vc = LiveTrackingVC()
            vc.order = order
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .fullScreen
            present(navVc, animated: true, completion: nil)  
            
        }
    }
    
}


extension HomeVc: OrderViewModelDelegate {
    func didFetchOrder(_ viewModel: OrderViewModel, order: OrderData) {
        DispatchQueue.main.async {
            self.orderData = order.data
            self.tableView.reloadData()
            self.pop.show = false
            self.refreshControl.endRefreshing()
        }
    }
    
    func didFailedGetOrder(_ error: Error) {
        DispatchQueue.main.async {
            self.orderData = []
            self.tableView.reloadData()
            self.pop.show = false
            self.refreshControl.endRefreshing()
        }
    }
}
