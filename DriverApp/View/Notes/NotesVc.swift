//
//  NotesVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

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
    
    private let labelEmpty = Reusable.makeLabel(font: .systemFont(ofSize: 14, weight: .regular), color: .black, numberOfLines: 0, alignment: .center)
    
    var noteViewModel = NoteViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var pendingData: [Note] = []
    var checkoutData: [Note] = []
    var codeDriver: String = ""
    var display: String = "PENDING"
    
    lazy var tableView: UITableView = {
       let table = UITableView()
        table.register(UINib(nibName: "CustomNoteCell", bundle: nil), forCellReuseIdentifier: CustomNoteCell .id)
        
       return table
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
    
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        
        configureLayout()
        
        view.addSubview(emptyImage)
        view.addSubview(labelEmpty)
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelEmpty.anchor(top: emptyImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        labelEmpty.isHidden = true
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
                    self?.labelEmpty.isHidden = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.pendingData = []
                    self?.tableView.reloadData()
                    self?.spiner.dismiss()
                    self?.emptyImage.isHidden = false
                    self?.labelEmpty.isHidden = false
                    self?.labelEmpty.text = error.localizedDescription
                }
            }
        }
    }
    
    func configureLayout(){
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.separatorStyle = .none
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "Notes".localiz()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomNoteCell.id, for: indexPath) as! CustomNoteCell
        
        cell.item = pendingData[indexPath.row]
        
        return cell
        
    }
    
}
