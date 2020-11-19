//
//  ProfileViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import AlamofireImage
import JGProgressHUD

@available(iOS 13.0, *)
class ProfileViewController: UIViewController {
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    var profileVM = ProfileViewModel()
    var inoutVm = InOutViewModel()
    var code: String = ""
    var idDriver: Int? = nil
    var user: UserModel? = nil
    
    var checkin: Bool = false
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.addSubview(lableName)
        container.addSubview(lableEmail)
        return container
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "personCircle")
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
    
    func createButton(title: String, color: UIColor? = nil)-> UIView {
        let buttonEditProfile: UIView = {
            let view = UIView()
            view.isUserInteractionEnabled = true
            let label: UILabel = {
                let lable = UILabel()
                lable.text = title
                if color != nil {
                    lable.textColor = color
                }
                
                return lable
            }()
            let image: UIImageView = {
               let img = UIImageView()
                let imageAset = UIImage(named: "arrowRight")
                let baru = imageAset?.resizeImage(CGSize(width: 20, height: 20))
                img.image = baru
                img.layer.masksToBounds = true
                img.contentMode = .right
                if color != nil {
                    img.tintColor = color
                }
                return img
            }()
            
            view.addSubview(label)
            view.addSubview(image)
            label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: image.leftAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 16, paddingRight: 5)
            image.anchor(top: view.topAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingRight: 16, width: 50)
            
            return view
        }()
        
        return buttonEditProfile
    }
    
    
    lazy var containerButton: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var button1 = createButton(title: "Edit Profile")
    lazy var button2 = createButton(title: "Change Password")
    lazy var button3 = createButton(title: "Checkout")
    lazy var button4 = createButton(title: "Rest")
    lazy var button5:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "logoutIcon")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Logout", for: .normal)
        b.setTitleColor(.red, for: .normal)
        b.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        b.centerTextAndImage(spacing: 10.0)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = UIColor(named: "bgKasumi")
        
        view.addSubview(containerView)
        
        view.addSubview(imageView)
        view.addSubview(containerButton)
        containerButton.addSubview(button1)
        containerButton.addSubview(button2)
        containerButton.addSubview(button3)
        containerButton.addSubview(button4)
        containerButton.addSubview(button5)
        
        profileVM.delegate = self
        configureLayout()
        configureNavigationBar()
    }
    
    
    func configureNavigationBar(){
        let image = UIImage(named: "chatIcon")
        let baru = image?.resizeImage(CGSize(width: 25, height: 25))
        navigationItem.title = "My Profile"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: baru, style: .plain, target: self, action: #selector(onClickChatButton))
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
        profileVM.getDetailUser(with: codeDriver)
        spiner.show(in: view)
        listenStatusDriver()
    }
    
    
    //MARK: - Listen status driver
    private func listenStatusDriver(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let idDriver = userData["idDriver"] as? Int, let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        inoutVm.cekStatusDriver(idDriver: idDriver) {[weak self] (result) in
            switch result {
            case .success(let status):
                print(status)
                DispatchQueue.main.async {
                    if status.isCheckin == true && status.isCheckout == true {
                        print("sudah out")
                        self?.button3.isHidden = true //hide
                        self?.button4.isHidden = true //hide
                    }else {
                        if status.isCheckin == true {
                            print("baru in")
                            self?.button3.isHidden = false //muncul
                            self?.profileVM.cekStatusDriver(codeDriver: codeDriver) {[weak self] (res) in
                                switch res {
                                case .success(let data):
                                    DispatchQueue.main.async {
                                        if data.restTime != nil {
                                            self?.button4.isHidden = true //hide
                                        }else {
                                            self?.button4.isHidden = false  //muncul
                                        }
                                    }
                                case .failure(let err):
                                    print(err)
                                }
                            }
                        }else {
                            self?.button3.isHidden = true
                        }
                    }
                }
                
            case .failure(let err):
                DispatchQueue.main.async {
                    print(err)
                }
            }
        }
        
    }
    
    //MARK: - Edit profile
    @objc
    private func didTapEditProfile(){
        let vc = EditProfileVc()
        vc.dataDriver = user
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Change password
    @objc
    private func didTapPassword(){
        let vc = ChangePasswordVC()
        vc.codeDriver = code
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Logout
    @objc
    private func didTapLogout(){
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
    
    //MARK: - Checkout
    @objc
    private func didTapCheckout(){
        let vc = CheckoutNoteView()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Rest time
    @objc
    func didTapRest(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let idDriver = userData["idDriver"] as? Int else {
            print("No user data")
            return
        }
        let action1 = UIAlertAction(title: "Yes", style: .default) {[weak self] (_) in
            let data: CheckDriver = CheckDriver(id_driver: idDriver)
            self?.spiner.show(in: (self?.view)!)
            self?.restNow(data: data)
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message: "Start rest now ?", customTitle: "Are you sure", customAction1: action1, customAction2: action2)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func restNow(data: CheckDriver){
        inoutVm.restTimeDriver(data: data) {[weak self] (res) in
            switch res {
            case .failure(let err):
                print(err)
                Helpers().showAlert(view: self!, message: "Something when wrong !")
                self?.spiner.dismiss()
            case .success(let oke):
                DispatchQueue.main.async {
                    if oke == true {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    self?.spiner.dismiss()
                }
            }
        }
    }
    
    
    //MARK: - Configure layout
    private func configureLayout(){
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height/3)
        
        containerView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 15+25+10+10+10)
        
        lableName.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        lableEmail.anchor(top: lableName.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        containerButton.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
        
        button1.anchor(top: containerButton.topAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEditProfile)))
        
        button2.anchor(top: button1.bottomAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPassword)))
        
        button3.anchor(top: button2.bottomAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCheckout)))
        button3.isHidden = true
        
        button4.anchor(top: button3.bottomAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRest)))
        button4.isHidden = true
        
        button5.anchor(left: containerButton.leftAnchor, bottom: containerButton.bottomAnchor, right: containerButton.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        button5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLogout)))
    }
    
}


//MARK: - Profile view model delegate
@available(iOS 13.0, *)
extension ProfileViewController: ProfileViewModelDelegate {
    func didFetchUser(_ viewModel: ProfileViewModel, user: UserModel, bio: Bio) {
        DispatchQueue.main.async {
            self.spiner.dismiss()
            if let urlString = URL(string: "\(bio.photo_url)\(bio.photo_name)")
            {
                self.user = user
                let placeholderImage = UIImage(named: "personCircle")
                
                self.imageView.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
                let fullName: String = "\(bio.first_name) \(bio.last_name)"
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

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1

        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
