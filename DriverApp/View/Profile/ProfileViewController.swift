//
//  ProfileViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import AlamofireImage
import JGProgressHUD

class ProfileViewController: UIViewController {
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    let actions:[[String:String]] = [["label":"Edit Profile","icon":"person"],
                                     ["label":"Change Password","icon":"person"],
                                     ["label":"Checkout","icon":"person"],
                                     ["label":"Rest","icon":"person"],
                                     ["label":"Logout","icon":"person"]]
    
    var profileVM = ProfileViewModel()
    var code: String = ""
    var idDriver: Int? = nil
    var user: UserModel? = nil
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.addSubview(lableName)
        container.addSubview(lableEmail)
        return container
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.rowHeight = 60
        table.register(ActionCell.self, forCellReuseIdentifier: ActionCell.id)
        table.isScrollEnabled = false
        table.alwaysBounceVertical = false
        return table
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.circle")
        image.tintColor = .white
        
        return image
    }()
    
    let lableName: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 25,weight: .bold)
        lable.textColor = .black
        
        return lable
    }()
    
    let lableEmail: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15,weight: .regular)
        lable.textColor = .lightGray
        
        return lable
    }()
    
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.addSubview(imageView)
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.addSubview(tableView)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        profileVM.delegate = self
        configureLayout()
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        navigationItem.title = "My Profile"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipses.bubble.fill"), style: .plain, target: self, action: #selector(onClickChatButton))
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get data detail user from local
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let id = userData["idDriver"] as? Int else {
            print("No user data")
            return
        }
        code = codeDriver
        idDriver = id
        // get data from api
        //        view.addSubview(pop)
        //        pop.show = true
        profileVM.getDetailUser(with: codeDriver)
        spiner.show(in: view)
    }
    
    @objc
    func didTapEditProfile(){
        let vc = EditProfileVc()
        vc.dataDriver = user
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapPassword(){
        let vc = ChangePasswordVC()
        vc.codeDriver = code
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapLogout(){
        let confirmationAlert = UIAlertController(title: "Are you sure ?",
                                                  message: "Do you want to logout ?",
                                                  preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self] (_) in
            UserDefaults.standard.removeObject(forKey: "userData")
            self?.dismiss(animated: false, completion: nil)
        }))
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func configureLayout(){
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height/3)
        
        containerView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 15+25+10+10+10)
        
        lableName.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        lableEmail.anchor(top: lableName.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        tableView.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
}


extension ProfileViewController: ProfileViewModelDelegate {
    func didFetchUser(_ viewModel: ProfileViewModel, user: UserModel) {
        DispatchQueue.main.async {
            self.spiner.dismiss()
            if let urlString = URL(string: "\(user.photoUrl)\(user.photoName)")
            {
                self.user = user
                let placeholderImage = UIImage(systemName: "person.circle")
                
                self.imageView.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
                let fullName: String = "\(user.firstName) \(user.lastName)"
                self.lableName.text = fullName
                self.lableEmail.text = user.email
                //                self.pop.show = false
            }
        }
    }
    
    func didFailedToFetch(_ error: Error) {
        print(error)
        spiner.dismiss()
        //        self.pop.show = false
    }
    
    
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionCell.id, for: indexPath) as! ActionCell
        
        let action = actions[indexPath.row]
        
        cell.lableAction.text = action["label"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = actions[indexPath.row]
        
        
        switch cell["label"] {
        case "Edit Profile":
            didTapEditProfile()
            break
        case "Change Password":
            didTapPassword()
            break
        case "Checkout":
            print("oke")
            break
        case "Rest":
            print("Okeeey")
            break
        case "Logout":
            didTapLogout()
            break
        default:
            print("No Action")
        }
        
    }
}
