//
//  ProfileViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    
    let pop = PopUpView()
    var profileVM = ProfileViewModel()
    var code: String = ""
    var idDriver: Int? = nil
    var user: UserModel? = nil
    
    lazy var containerView: UIView = {
     let container = UIView()
        container.backgroundColor = .mainBlue
        container.addSubview(imageView)
        container.addSubview(lableName)
        container.addSubview(lableEmail)
        return container
    }()
    
    let imageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 120/2
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.image = UIImage(systemName: "person.circle")
        image.tintColor = .white
        
        return image
    }()
    
    let lableName: UILabel = {
        let lable = UILabel()
//        lable.text = "Current User is logged in"
        lable.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        lable.textAlignment = .center
        lable.textColor = .white
        lable.numberOfLines = 0
        
        return lable
    }()
    
    let lableEmail: UILabel = {
        let lable = UILabel()
//        lable.text = "user@gmail.com"
        lable.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        lable.textAlignment = .center
        lable.textColor = .white
        
        return lable
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor  = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16,weight:.bold)
        button.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
        return button
    }()
    
    let passwordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.backgroundColor  = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16,weight:.bold)
        
        return button
    }()
    
    let checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check Out", for: .normal)
        button.backgroundColor  = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16,weight:.bold)
        
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor  = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16,weight:.bold)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        view.addSubview(profileButton)
        view.addSubview(logoutButton)
        view.addSubview(checkoutButton)
        view.addSubview(passwordButton)
        
        profileVM.delegate = self
        
        configureLayout()
        
       
        
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        passwordButton.addTarget(self, action: #selector(didTapPassword), for: .touchUpInside)
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
        view.addSubview(pop)
        pop.show = true
        profileVM.getDetailUser(with: codeDriver)
    }
    
    @objc
    func didTapEditProfile(){
        let vc = EditProfileVc()
        vc.dataDriver = user
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
    }
    
    @objc func didTapPassword(){
        let vc = ChangePasswordVC()
        vc.codeDriver = code
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
    }
    
    @objc func didTapLogout(){
        let confirmationAlert = UIAlertController(title: "Are you sure ?",
                                                  message: "Do you want to logout ?",
                                                  preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self] (_) in
            UserDefaults.standard.removeObject(forKey: "userData")
            self?.dismiss(animated: true, completion: nil)
        }))
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func configureLayout(){
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, height: 300)
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.anchor(top: containerView.topAnchor, paddingTop: 88, width: 120, height: 120)
        lableName.anchor(top: imageView.bottomAnchor,
                         left: containerView.leftAnchor,
                         right: containerView.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 20,
                         paddingRight: 20)
        lableEmail.anchor(top: lableName.bottomAnchor,
                         left: containerView.leftAnchor,
                         right: containerView.rightAnchor,
                         paddingTop: 10,
                         paddingLeft: 20,
                         paddingRight: 20)
        profileButton.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 50)
        passwordButton.anchor(top: profileButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 50)
        checkoutButton.anchor(top: passwordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 50)
        logoutButton.anchor(top: checkoutButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 50)
    }

}


extension ProfileViewController: ProfileViewModelDelegate {
    func didFetchUser(_ viewModel: ProfileViewModel, user: UserModel) {
        DispatchQueue.main.async {
            if let urlString = URL(string: "\(user.photoUrl)\(user.photoName)")
               {
                self.user = user
                let placeholderImage = UIImage(systemName: "person.circle")
                
                self.imageView.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
                let fullName: String = "\(user.firstName) \(user.lastName)"
                self.lableName.text = fullName
                self.lableEmail.text = user.email
                self.pop.show = false
            }
        }
    }
    
    func didFailedToFetch(_ error: Error) {
        print(error)
        self.pop.show = false
    }
    
    
}
