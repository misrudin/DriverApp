//
//  HistoryViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

@available(iOS 13.0, *)
class HistoryViewController: UIViewController {
    
    var profileVm = ProfileViewModel()
    
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
    
    private let labelEmpty = Reusable.makeLabel(font: .systemFont(ofSize: 14, weight: .regular), color: .black, numberOfLines: 0, alignment: .center)
    
    var orderData: [History]?
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    lazy var refreshControl = UIRefreshControl()

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: HistoryCell.id)
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localiz())
        refreshControl.addTarget(self, action: #selector(getDataOrder), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        view.addSubview(emptyImage)
        view.addSubview(labelEmpty)
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelEmpty.anchor(top: emptyImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        labelEmpty.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataOrder()
        configureNavigationBar()
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
                    self?.orderData = order
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = true
                    self?.labelEmpty.isHidden = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.orderData = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.refreshControl.endRefreshing()
                    self?.emptyImage.isHidden = false
                    self?.labelEmpty.isHidden = false
                    self?.labelEmpty.text = error.localizedDescription
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
        
        navigationItem.title = "Jobs History".localiz()
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
        let vc = ChatView()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

@available(iOS 13.0, *)
extension HistoryViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderData = orderData {
            return orderData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.id, for: indexPath) as! HistoryCell
        
        if let orderData = orderData {
            cell.item = orderData[indexPath.row]
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print(indexPath.row)
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
 
        let deleteAction = UIContextualAction(
            style: .normal,
               title: "Delete",
            handler: {[weak self](action, view, completion) in
                   completion(true)
                guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                      let codeDriver = userData["codeDriver"] as? String, let order = self?.orderData else {
                    print("No user data")
                    return
                }
                let orderNo = order[indexPath.row].order_number
                
                let data: DeleteHistory = DeleteHistory(order_number: orderNo, code_driver: codeDriver)
                OrderViewModel().deleteOrder(data: data) { (res) in
                    switch res {
                    case .success(let oke):
                        if oke {
                            self?.orderData?.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    case .failure(let err):
                        print(err)
                        Helpers().showAlert(view: self!, message: "Failed to delete history !")
                    }
                }
           })


        let imageDelete = UIImage(named: "deleteIcon")
        let delete = imageDelete?.resizeImage(CGSize(width: 25, height: 25))
    
        deleteAction.image = delete
        deleteAction.backgroundColor = .red
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
    }
}
