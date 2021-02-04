//
//  SelectAdmin.swift
//  DriverApp
//
//  Created by Indo Office4 on 03/02/21.
//

import UIKit
import JGProgressHUD

class SelectAdmin: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
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
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(AdminCell.self, forCellReuseIdentifier: AdminCell.id)
        table.backgroundColor = UIColor(named: "whiteKasumi")
        table.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = 0
        table.separatorStyle = .none
        return table
    }()
    
    
    private var presentingController: UIViewController?
    var vm = ChatViewModel()
    
    var admins: [Admin]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        getListAdmin()
        configureUI()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localiz())
        refreshControl.addTarget(self, action: #selector(getListAdmin), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingController = presentingViewController
    }
    
    private func configureUI(){
        view.addSubviews(views: tableView, emptyImage, labelEmpty)
        tableView.addSubview(refreshControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.centerX(toAnchor: view.centerXAnchor)
        emptyImage.centerY(toAnchor: view.centerYAnchor)
        labelEmpty.anchor(top: emptyImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        labelEmpty.isHidden = true
        
        tableView.fill(toView: view)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @objc private func getListAdmin(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let idGroup = userData["idGroup"] as? Int else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        vm.getListAdminByGroup(idGroup: idGroup) { (res) in
            switch res {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    self.admins = data
                    self.emptyImage.isHidden = true
                    self.labelEmpty.isHidden = true
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.spiner.dismiss()
                self.admins = nil
                self.emptyImage.isHidden = true
                self.labelEmpty.isHidden = true
                self.labelEmpty.text = err.localizedDescription
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Customer Service".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(back))
    }
    
    @objc private func back(){
        self.presentingController?.dismiss(animated: false)
        NotificationCenter.default.post(name: .didCloseAdmin, object: nil)
    }
}


extension SelectAdmin: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let adminData = admins {
            return adminData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminCell.id, for: indexPath) as! AdminCell
        if let adminData = admins {
            cell.admin = adminData[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let adminData = admins {
            let admin = adminData[indexPath.row]
            UserDefaults.standard.setValue(admin.iduser, forKey: "idAdmin")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .didSelectAdmin, object: nil)
        }
    }
    
}


class AdminCell: UITableViewCell {
    static let id = "AdminCell"
    
    var admin: Admin! {
        didSet {
            adminName.text = "\(admin.first_name) \(admin.last_name)"
            employeeCode.text = "\(admin.employee_number)"
        }
    }

    let imageAdmin = Reusable.makeImageView(image: UIImage(named: "admin")!, contentMode: .scaleToFill)
    let adminName = Reusable.makeLabel(font: .systemFont(ofSize: 16, weight: .regular), color: UIColor(named: "darkKasumi")!, numberOfLines: 0, alignment: .left)
    let employeeCode = Reusable.makeLabel(font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(named: "orangeKasumi")!, numberOfLines: 0, alignment: .left)
    
    let viewContainer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(viewContainer)
        viewContainer.addSubviews(views: imageAdmin, adminName, employeeCode)
        imageAdmin.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        adminName.translatesAutoresizingMaskIntoConstraints = false
        employeeCode.translatesAutoresizingMaskIntoConstraints = false
        
        viewContainer.left(toAnchor: leftAnchor, space: 10)
        viewContainer.top(toAnchor: topAnchor, space: 5)
        viewContainer.right(toAnchor: rightAnchor, space: -10)
        viewContainer.bottom(toAnchor: bottomAnchor, space: -5)
        viewContainer.backgroundColor = UIColor(named: "colorGray")
        viewContainer.layer.cornerRadius = 5
        
        imageAdmin.top(toAnchor: viewContainer.topAnchor, space: 10)
        imageAdmin.left(toAnchor: viewContainer.leftAnchor, space: 10)
        imageAdmin.bottom(toAnchor: viewContainer.bottomAnchor, space: -10)
        imageAdmin.height(50)
        imageAdmin.width(50)
        
        employeeCode.left(toAnchor: imageAdmin.rightAnchor, space: 10)
        employeeCode.top(toAnchor: viewContainer.topAnchor, space: 10)
        employeeCode.right(toAnchor: viewContainer.rightAnchor, space: -10)
        
        adminName.top(toAnchor: employeeCode.bottomAnchor, space: 5)
        adminName.left(toAnchor: imageAdmin.rightAnchor, space: 10)
        adminName.right(toAnchor: viewContainer.rightAnchor, space: -10)
        adminName.bottom(toAnchor: viewContainer.bottomAnchor, space: -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
