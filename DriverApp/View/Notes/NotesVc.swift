//
//  NotesVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import JGProgressHUD

@available(iOS 13.0, *)
class NotesVc: UIViewController {
    
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
    
    var noteViewModel = NoteViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    var pendingData: [Note] = []
    var checkoutData: [Note] = []
    var codeDriver: String = ""
    var display: String = "PENDING"
    
    lazy var tableView: UITableView = {
       let table = UITableView()
        table.register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
        
       return table
    }()
    
    
//    lazy var segmentC: UISegmentedControl = {
//        let segment = UISegmentedControl(items: ["Checkout", "Pending"])
//        segment.layer.cornerRadius = 5
//        segment.selectedSegmentIndex = 0
//        segment.addTarget(self, action: #selector(changeColor(sender:)), for: .valueChanged)
//        return segment
//    }()
    
    var containerButton: UIView = {
       let container = UIView()
        container.backgroundColor = UIColor(named: "orangeKasumi")

       return container
    }()
    
//    @objc func changeColor(sender: UISegmentedControl) {
//          switch sender.selectedSegmentIndex {
//          case 0:
//            didTapCheckout()
//          case 1:
//            didTapPending()
//          default:
//            didTapCheckout()
//          }
//      }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
    
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        
        configureLayout()
        
        view.addSubview(emptyImage)
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyImage.dropShadow(color: UIColor(named: "orangeKasumi")!, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 120/2, scale: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        self.codeDriver = codeDriver
        didTapPending()
    }
    
 
    
    @objc
    func didTapPending(){
        spiner.show(in: view)
        emptyImage.isHidden = true
        noteViewModel.getDataNotePending(codeDriver: codeDriver) {[weak self] (result) in
            self?.display = "PENDING"
            switch result {
            case .success(let dataPending):
                DispatchQueue.main.async {
                    self?.pendingData = dataPending
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.emptyImage.isHidden = true
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.pendingData = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.emptyImage.isHidden = false
                }
            }
        }
    }
    
    func configureLayout(){
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "Notes"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
}


@available(iOS 13.0, *)
extension NotesVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display == "CHECKOUT" ? checkoutData.count : pendingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as! NoteCell
        
        
        cell.labelNote.text = display == "CHECKOUT" ? checkoutData[indexPath.row].note : pendingData[indexPath.row].note
        cell.labelTime.text = display == "CHECKOUT" ? "\(checkoutData[indexPath.row].created_date), \(checkoutData[indexPath.row].created_time[...4])" : "\(pendingData[indexPath.row].created_date), \(pendingData[indexPath.row].created_time[...4])"
        
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
        let id:Int = display == "CHECKOUT" ? checkoutData[indexPath.row].id_note : pendingData[indexPath.row].id_note
        
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
                    self?.noteViewModel.deleteNote(id: id, completion: { (response) in
                        switch response {
                        case .success(_):
                            self?.checkoutData.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        case .failure(_):
                            Helpers().showAlert(view: self!, message: "Failed to delete note !")
                        }
                    })
                }else {
                    self?.noteViewModel.deleteNote(id: id, completion: {[weak self] (response) in
                        switch response {
                        case .success(_):
                            self?.pendingData.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        case .failure(_):
                            Helpers().showAlert(view: self!, message: "Failed to delete note !")
                        }
                    })
                }
           })

        let imageEdit = UIImage(named: "editIcon")
        let edit = imageEdit?.resizeImage(CGSize(width: 25, height: 25))
        
        let imageDelete = UIImage(named: "deleteIcon")
        let delete = imageDelete?.resizeImage(CGSize(width: 25, height: 25))
        
        editAction.image = edit
        editAction.backgroundColor = UIColor(named: "yellowKasumi")
        deleteAction.image = delete
        deleteAction.backgroundColor = .red
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
    }
    
    
}
