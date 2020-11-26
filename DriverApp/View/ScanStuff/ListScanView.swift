//
//  ListScanView.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit

class ListScanView: UIViewController {
    
    //MARK: - COMPONENTS
    lazy var scanButton:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "logoutIcon")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Scan QR Code to Verify", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "orangeKasumi")
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold )
        b.centerTextAndImage(spacing: 10.0)
        return b
    }()
    
    lazy var manualButotn:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "logoutIcon")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Add  Code Manually", for: .normal)
        b.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular )
        b.centerTextAndImage(spacing: 10.0)
        return b
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
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
    
    //MARK: - FUNCTIONS
    private func configureUi(){
        view.addSubview(tableView)
        view.addSubviews(views: scanButton, manualButotn)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: scanButton.topAnchor, right: view.rightAnchor,paddingBottom: 40)
        
        manualButotn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        scanButton.anchor(left: view.leftAnchor, bottom: manualButotn.topAnchor, right: view.rightAnchor, paddingBottom: 10, paddingLeft: 16, paddingRight: 16, height: 45)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.title = "Delivery Order List"
    }
    
    @objc func inputCodeManual(){
        let vc = InputCode()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ListScanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
