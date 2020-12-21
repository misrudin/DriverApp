//
//  ProfileViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 15/10/20.
//

import UIKit
import AlamofireImage
import JGProgressHUD
import LanguageManager_iOS

@available(iOS 13.0, *)
class ProfileViewController: UIViewController {
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var profileVM = ProfileViewModel()
    var inoutVm = InOutViewModel()
    var code: String = ""
    var idDriver: Int? = nil
    var user: UserModel? = nil
    var bioData: Bio? = nil
    var vehicleData: VehicleData? = nil
    
    var checkin: Bool = false
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .rgba(red: 0, green: 0, blue: 0, alpha: 0.025)
        container.addSubview(lableName)
        container.addSubview(lableEmail)
        container.addSubview(imageView)
        return container
    }()
    
    
    lazy var imageView = Reusable.makeImageView(contentMode: .scaleAspectFill)
    
    lazy var lableName = Reusable.makeLabel(font: UIFont.systemFont(ofSize: 18,weight: .semibold))
    
    lazy var lableEmail = Reusable.makeLabel()
    
    lazy var imageEdit = Reusable.makeImageView(image: UIImage(named: "editIconGray")!, contentMode: .scaleAspectFit)
    
    func createButton(title: String, color: UIColor? = nil, icon: UIImage)-> UIView {
        let buttonEditProfile: UIView = {
            let view = UIView()
            view.isUserInteractionEnabled = true
            let imageR: UIImageView = {
                let iv = UIImageView()
                iv.contentMode = .scaleAspectFit
                iv.clipsToBounds = true
                iv.layer.masksToBounds = true
                iv.image = icon
                return iv
            }()
            
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
            view.addSubview(imageR)
            label.anchor(top: view.topAnchor, left: imageR.rightAnchor, bottom: view.bottomAnchor, right: image.leftAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 5)
            image.anchor(top: view.topAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingBottom: 5, paddingRight: 16, width: 50)
            
            imageR.anchor(left: view.leftAnchor, paddingLeft: 16, width: 30,height: 30)
            imageR.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            return view
        }()
        
        return buttonEditProfile
    }
    
    
    lazy var containerButton: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var button1 = createButton(title: "Note".localiz(), icon: UIImage(named: "note")!)
    lazy var button2 = createButton(title: "Change Password".localiz(), icon: UIImage(named: "password")!)
    lazy var button6 = createButton(title: "Change Vehicle Data".localiz(), icon: UIImage(named: "vehicle")!)

    //MARK: - Ratings
    lazy var ratingLabel: UILabel = {
        let lable = UILabel()
        lable.text = "0"
        lable.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lable.textColor = UIColor(named: "darkKasumi")
        return lable
    }()
    
    lazy var rating1: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "star2")
        return img
    }()
    
    lazy var rating2: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "star2")
        return img
    }()
    
    lazy var rating3: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "star2")
        return img
    }()
    
    lazy var rating4: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "star2")
        return img
    }()
    
    lazy var rating5: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "star2")
        return img
    }()
    
    lazy var button5:UIButton = {
        let b = UIButton()
        let image = UIImage(named: "logoutIcon")
        let baru = image?.resizeImage(CGSize(width: 15, height: 15))
        
        b.setImage(baru, for: .normal)
        b.setTitle("Logout".localiz(), for: .normal)
        b.setTitleColor(.red, for: .normal)
        b.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        b.centerTextAndImage(spacing: 10.0)
        return b
    }()
    
    lazy var button3:UIButton = {
        let b = UIButton()
        b.setTitle("Checkout".localiz(), for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(named: "darkKasumi")
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        return b
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.layer.cornerRadius = 80/2
        imageEdit.isUserInteractionEnabled = true
        imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEditProfile)))
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        
        view.addSubview(containerButton)
        containerButton.addSubview(button1)
        containerButton.addSubview(button2)
        containerButton.addSubview(button3)
//        containerButton.addSubview(button4)
        containerButton.addSubview(button5)
        containerButton.addSubview(button6)
//        containerButton.addSubview(button7)
        
        profileVM.delegate = self
        configureLayout()
        configureNavigationBar()
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        profileVM.getDetailUser(with: codeDriver)
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "My Profile".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
   
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
        listenStatusDriver()
    }
    
    
    //MARK: - Listen status driver
    private func listenStatusDriver(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        inoutVm.cekStatusDriver(codeDriver: codeDriver) {[weak self] (result) in
            switch result {
            case .success(let status):
                print(status)
                DispatchQueue.main.async {
                    if status.isCheckin == true && status.isCheckout == true {
                        print("sudah out")
                        self?.button3.isHidden = true //hide
                        
                    }else {
                        if status.isCheckin == true {
                            print("baru in")
                            self?.button3.isHidden = false //muncul
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
        vc.bio = bioData
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
    
    @objc func didTapNote(){
        let vc = NotesVc()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Edit Vehicle
    @objc
    private func didTapVehicle(){
        let vc = EditVehicleView()
        vc.codeDriver = code
        vc.vehicleData = vehicleData
        vc.change = 0
        vc.bioData = bioData
        vc.userData = user
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Edit Email
    @objc
    private func didTapEmail(){
        let vc = EditEmail()
        vc.codeDriver = code
        vc.driverEmail = user!.email
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Logout
    @objc
    private func didTapLogout(){
        let confirmationAlert = UIAlertController(title: "Are you sure ?".localiz(),
                                                  message: "Do you want to logout ?".localiz(),
                                                  preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: {[weak self] (_) in
            UserDefaults.standard.removeObject(forKey: "userData")
            self?.dismiss(animated: true, completion: nil)
        }))
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    //MARK: - Checkout
    @objc
    private func didTapCheckout(){
        let action1 = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "Yes, Checkout".localiz(), style: .default) {[weak self] (_) in
            self?.didCheckout()
        }
        
        Helpers().showAlert(view: self, message: "Do you want to checkout now".localiz(), customTitle: "Are you sure ?".localiz(), customAction1: action1, customAction2: action2)
    }
    
    private func didCheckout(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        let driver: CheckDriver = CheckDriver(code_driver: codeDriver)
        inoutVm.checkoutDriver(data: driver) {[weak self] (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                        self?.spiner.dismiss()
                }
            case .failure(let err):
                print(err)
                self?.spiner.dismiss()
                Helpers().showAlert(view: self!, message: "Something when wrong !".localiz())
            }
        }
    }
    
    

    
    
    //MARK: - Configure layout
    private func configureLayout(){
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        containerView.addSubview(imageEdit)
        
        lableName.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, right: imageEdit.leftAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 10)
        
        lableEmail.anchor(top: lableName.bottomAnchor, left: imageView.rightAnchor, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        
        
        imageEdit.anchor(top: containerView.topAnchor, right: containerView.rightAnchor, paddingTop: 25, paddingRight: 16, width: 20, height: 20)
        
        imageView.anchor(left: containerView.leftAnchor, paddingLeft: 16, width: 80, height: 80)
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerButton.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
        
        
        button1.anchor(top: containerButton.topAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNote)))
        
        button2.anchor(top: button1.bottomAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPassword)))
        
        button6.anchor(top: button2.bottomAnchor, left: containerButton.leftAnchor, right: containerButton.rightAnchor, height: 50)
        button6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapVehicle)))
        
        
        button3.anchor(left: containerButton.leftAnchor,bottom: button5.topAnchor, right: containerButton.rightAnchor,paddingBottom: 16,paddingLeft: 16,paddingRight: 16, height: 45)
        button3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCheckout)))
        button3.isHidden = true
        
        button5.anchor(left: containerButton.leftAnchor, bottom: containerButton.bottomAnchor, right: containerButton.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        button5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLogout)))
        
        //ratings
        containerView.addSubviews(views: rating1,rating2,rating3,rating4,rating5,ratingLabel)
        ratingLabel.anchor(top: lableEmail.bottomAnchor,left: imageView.rightAnchor,paddingTop: 10, paddingLeft: 16)
        rating1.anchor(left: ratingLabel.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating2.anchor(left: rating1.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating3.anchor(left: rating2.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating4.anchor(left: rating3.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating5.anchor(left: rating4.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        
        [rating1,rating2,rating3,rating4,rating5].forEach { (i) in
            i.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor).isActive = true
        }
        
    }
    
}


//MARK: - Profile view model delegate
@available(iOS 13.0, *)
extension ProfileViewController: ProfileViewModelDelegate {
    func didFetchUser(_ viewModel: ProfileViewModel, user: UserModel, bio: Bio, vehicle: VehicleData) {
        DispatchQueue.main.async {
            self.spiner.dismiss()
            if let urlString = URL(string: "\(bio.photo_url)\(bio.photo_name)")
            {
                self.user = user
                self.bioData = bio
                self.vehicleData = vehicle
                let placeholderImage = UIImage(named: "profileIcon")
                
                self.imageView.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
                let fullName: String = "\(bio.first_name) \(bio.last_name)"
                self.lableName.text = fullName
                self.lableEmail.text = user.email
                
                
                //MARK: -Ratings
                let numberFormater = NumberFormatter()
                numberFormater.numberStyle = .decimal
                let totalRatingDecimal = numberFormater.number(from: user.rating.avgRating!)
                
                self.ratingLabel.text = "\(totalRatingDecimal ?? 0)"
                
                guard let totalRating: Double = Double((user.rating.avgRating)!) else {
                    return
                }
                
                if totalRating == 0 {
                    self.rating1.image = UIImage(named: "star2")
                    self.rating2.image = UIImage(named: "star2")
                    self.rating3.image = UIImage(named: "star2")
                    self.rating4.image = UIImage(named: "star2")
                    self.rating5.image = UIImage(named: "star2")
                }
                
                if totalRating > 0  && totalRating >= 1 {
                    self.rating1.image = UIImage(named: "star")
                    self.rating2.image = UIImage(named: "star2")
                    self.rating3.image = UIImage(named: "star2")
                    self.rating4.image = UIImage(named: "star2")
                    self.rating5.image = UIImage(named: "star2")
                }
                
                if (totalRating) > 1  && (totalRating) >= 2 {
                    self.rating1.image = UIImage(named: "star")
                    self.rating2.image = UIImage(named: "star")
                    self.rating3.image = UIImage(named: "star2")
                    self.rating4.image = UIImage(named: "star2")
                    self.rating5.image = UIImage(named: "star2")
                }
                
                if (totalRating) > 2  && (totalRating) >= 3 {
                    self.rating1.image = UIImage(named: "star")
                    self.rating2.image = UIImage(named: "star")
                    self.rating3.image = UIImage(named: "star")
                    self.rating4.image = UIImage(named: "star2")
                    self.rating5.image = UIImage(named: "star2")
                }
                
                if (totalRating) > 3  && (totalRating) >= 4 {
                    self.rating1.image = UIImage(named: "star")
                    self.rating2.image = UIImage(named: "star")
                    self.rating3.image = UIImage(named: "star")
                    self.rating4.image = UIImage(named: "star")
                    self.rating5.image = UIImage(named: "star2")
                }
                
                if (totalRating) > 4  && (totalRating) >= 5 {
                    self.rating1.image = UIImage(named: "star")
                    self.rating2.image = UIImage(named: "star")
                    self.rating3.image = UIImage(named: "star")
                    self.rating4.image = UIImage(named: "star")
                    self.rating5.image = UIImage(named: "star")
                }
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
