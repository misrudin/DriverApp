//
//  NotesVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

class NotesVc: UIViewController {
    
    var noteViewModel = NoteViewModel()
    let pop = PopUpView()
    
    var pendingData: [Pending] = []
    var checkoutData: [Checkout] = []
    var codeDriver: String = ""
    var display: String = "CHECKOUT"
    
    lazy var tableView: UITableView = {
       let table = UITableView()
        table.register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
        
       return table
    }()
    
     var checkoutButton: UIButton={
        let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular )
        button.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
        return button
    }()
    
     var pendingButton: UIButton={
        let button = UIButton()
        button.setTitle("Pending", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular )
        button.addTarget(self, action: #selector(didTapPending), for: .touchUpInside)
        return button
    }()
    
    var containerButton: UIView = {
       let container = UIView()
        container.backgroundColor = UIColor(named: "orangeKasumi")

       return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(containerButton)
        containerButton.addSubview(checkoutButton)
        containerButton.addSubview(pendingButton)
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get data detail user from local
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        self.codeDriver = codeDriver
        // get data from api
        
        view.addSubview(pop)
        pop.show = true
        
        noteViewModel.getDataNoteCheckout(codeDriver: codeDriver) { (result) in
            switch result {
            case .success(let dataCheckout):
                DispatchQueue.main.async {
                    self.checkoutData = dataCheckout.data
                    self.tableView.reloadData()
                    self.pop.show = false
                }
            case .failure(let error):
                print(error)
                self.pop.show = false
            }
        }
    }
    
    @objc
    func didTapCheckout(){
        view.addSubview(pop)
        self.pop.show = true
        noteViewModel.getDataNoteCheckout(codeDriver: codeDriver) { (result) in
            self.display = "CHECKOUT"
            switch result {
            case .success(let dataCheckout):
                DispatchQueue.main.async {
                    self.checkoutData = dataCheckout.data
                    self.tableView.reloadData()
                    self.pop.show = false
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.checkoutData = []
                    self.tableView.reloadData()
                    self.pop.show = false
                }
            }
        }
    }
    
    @objc
    func didTapPending(){
        view.addSubview(pop)
        self.pop.show = true
        noteViewModel.getDataNotePending(codeDriver: codeDriver) { (result) in
            self.display = "PENDING"
            switch result {
            case .success(let dataPending):
                DispatchQueue.main.async {
                    self.pendingData = dataPending.data
                    self.tableView.reloadData()
                    self.pop.show = false
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.pendingData = []
                    self.tableView.reloadData()
                    self.pop.show = false
                }
            }
        }
    }
    
    func configureLayout(){
        containerButton.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 50)
        checkoutButton.anchor(top: containerButton.topAnchor, left: containerButton.leftAnchor, bottom: containerButton.bottomAnchor, width: view.frame.size.width/2)
        pendingButton.anchor(top: containerButton.topAnchor, bottom: containerButton.bottomAnchor, right: containerButton.rightAnchor,width: view.frame.size.width/2)
        
        tableView.anchor(top: containerButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "Notes"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    }

    
    @objc func didTapBack(){
        dismiss(animated: true, completion: nil)
    }

}


extension NotesVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display == "CHECKOUT" ? checkoutData.count : pendingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as! NoteCell
        
    
        cell.labelNote.text = display == "CHECKOUT" ? checkoutData[indexPath.row].note : pendingData[indexPath.row].note
        
        return cell
        
    }
    
    
}
