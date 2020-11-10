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
        
        if display == "CHECKOUT" {
            didTapCheckout()
        }else {
            didTapPending()
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
        tableView.separatorStyle = .none
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "Notes"
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
        cell.labelTime.text = display == "CHECKOUT" ? "\(checkoutData[indexPath.row].createdDate), \(checkoutData[indexPath.row].createdTime)" : "\(pendingData[indexPath.row].createdDate), \(pendingData[indexPath.row].createdTime)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let note = display == "CHECKOUT" ? checkoutData[indexPath.row].note : pendingData[indexPath.row].note
        let id:Int = display == "CHECKOUT" ? checkoutData[indexPath.row].idNote : pendingData[indexPath.row].idNote
        
        let editAction = UIContextualAction(
               style: .normal,
               title: "Edit",
               handler: {[weak self] (action, view, completion) in
                   completion(true)
                let vc =  EditNoteView()
                vc.id = id
                vc.note = note
                vc.type = self?.display
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
                
           })
        let deleteAction = UIContextualAction(
            style: .normal,
               title: "Delete",
            handler: {[weak self](action, view, completion) in
                   completion(true)
                if self?.display == "CHECKOUT" {
                    self?.noteViewModel.deleteCheckoutNote(id: id) {[weak self] (response) in
                        switch response {
                        case .success(_):
                            self?.checkoutData.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }else {
                    self?.noteViewModel.deletePendingNote(id: id) {[weak self] (response) in
                        switch response {
                        case .success(_):
                            self?.pendingData.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
           })

        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = UIColor(named: "yellowKasumi")
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor.systemRed
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
    }
    
    
}
