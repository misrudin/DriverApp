//
//  EditProfileVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 23/10/20.
//

import UIKit
import AlamofireImage
import JGProgressHUD

@available(iOS 13.0, *)
class EditProfileVc: UIViewController {
    
    var dataDriver: UserModel? = nil
    var bio: Bio? = nil
    var profileVm = ProfileViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    //MARK: - personal data
    lazy var personalLabel: UILabel = {
        let lable = UILabel()
        lable.text = "PERSONAL INFORMATION"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var profilePhotoImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 80/2
        img.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        return img
    }()

    //MARK: - Name
    lazy var firstNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "First Name"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var firstName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "First Name"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        field.isEnabled = false
        return field
    }()
    
    lazy var lastNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "Last Name"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var lastName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Last Name"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        field.isEnabled = false
        return field
    }()
    
    //MARK:- Email
    lazy var emailLable: UILabel = {
        let lable = UILabel()
        lable.text = "Email"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var email: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Email"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        field.keyboardType = .emailAddress
        field.isEnabled = false
        return field
    }()
    
    //MARK:- PhoneNumber
    lazy var phoneNumberLable: UILabel = {
        let lable = UILabel()
        lable.text = "Phone Number"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var phoneNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "123456"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.keyboardType = .numberPad
        field.returnKeyType = .continue
        return field
    }()
    
    
    //MARK: - submit button
    private let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - Scroll View
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        scroll.frame = self.view.bounds
        return scroll
    }()
    
    lazy var stakView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let lableCoutryCode: UILabel = {
       let label = UILabel()
        label.text = "+81"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        
        
        configureLayout()

        firstName.text = bio?.first_name
        lastName.text = bio?.last_name
        email.text = dataDriver?.email
        phoneNumber.text = bio?.phone_number

        
        guard let photoUrl = bio?.photo_url, let photoName = bio?.photo_name else {return}
        if let urlString = URL(string: "\(photoUrl)\(photoName)") {
            let placeholderImage = UIImage(named: "personCircle")
            self.profilePhotoImage.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
        }
    }
    
    @objc
    func updateProfile(){
        guard let phoneNumber = self.phoneNumber.text,
              let firstName = self.firstName.text,
              let lastName = self.lastName.text,
              let brith = bio?.birthday_date,
              let postalCode = bio?.postal_code,
              let pre = bio?.prefecture,
              let municDis = bio?.municipal_district,
              let chome = bio?.chome,
              let municKana = bio?.municipality_kana,
              let kanaAddres = bio?.kana_after_address,
              let sex = bio?.sex,
              let driverLicenseNumber = bio?.driver_license_number,
              let driverExp = bio?.driver_license_expiration_date,
              let driverPhotourl = bio?.photo_url,
              let photoName = bio?.photo_name
              else {
            return
        }
        
        let personalData: PersonalData = PersonalData(first_name: firstName,
                                                      last_name: lastName,
                                                      birthday_date: brith,
                                                      postal_code: postalCode,
                                                      prefecture: pre,
                                                      municipal_district: municDis,
                                                      chome: chome,
                                                      municipality_kana: municKana,
                                                      kana_after_address: kanaAddres,
                                                      sex: sex,
                                                      driver_license_number: driverLicenseNumber,
                                                      driver_license_expiration_date: driverExp,
                                                      photo_url: driverPhotourl,
                                                      photo_name: photoName,
                                                      photo: nil,
                                                      phone_number: phoneNumber)
        
        guard let bio: String = profileVm.encryptBio(data: personalData, codeDriver: dataDriver!.code_driver) else {return}
        
        let dataTopost: UpdatePersonal = UpdatePersonal(bio: bio, code_driver: dataDriver!.code_driver)
        
        let action = UIAlertAction(title: "Oke", style: .default) { (_) in
            self.startsubmit(data: dataTopost)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message:"Continue to edit profile ?", customTitle: "Are Sure", customAction1: action, customAction2: action2)
    }
    
    
    private func startsubmit(data: UpdatePersonal){
        spiner.show(in: view)
        profileVm.updateProfile(data: data) { (res) in
            switch res {
            case .success(let oke):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    if oke {
                        let action = UIAlertAction(title: "Oke", style: .default) { (_) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        Helpers().showAlert(view: self, message:"Succes edit profile", customTitle: "Sucess", customAction1: action)
                    }
                }
            case .failure(let err):
                Helpers().showAlert(view: self, message: err.localizedDescription, customTitle: "Error")
                self.spiner.dismiss()
            }
        }
    }
    
    func configureLayout(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height:(55*9))
        
        stakView.addSubview(personalLabel)
        personalLabel.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        stakView.addSubview(profilePhotoImage)
        profilePhotoImage.anchor(top: personalLabel.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15, width: 80, height: 80)
        
        stakView.addSubview(firstNameLable)
        firstNameLable.anchor(top: profilePhotoImage.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(firstName)
        firstName.anchor(top: firstNameLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(lastNameLable)
        lastNameLable.anchor(top: profilePhotoImage.bottomAnchor,left: firstNameLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(lastName)
        lastName.anchor(top: lastNameLable.bottomAnchor,left: firstName.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(emailLable)
        emailLable.anchor(top: firstName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(email)
        email.anchor(top: emailLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(phoneNumberLable)
        phoneNumberLable.anchor(top: email.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(phoneNumber)
        phoneNumber.anchor(top: phoneNumberLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(submitButton)
        submitButton.anchor(top: phoneNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 20, height: 45)
    }
    

    func configureNavigationBar(){
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
    }
}
