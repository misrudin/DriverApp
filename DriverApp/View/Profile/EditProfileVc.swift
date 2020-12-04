//
//  EditProfileVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 23/10/20.
//

import UIKit
import AlamofireImage
import JGProgressHUD
import AutoKeyboard

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
    //Toolbar done button function
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
    
    lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        tool.barStyle = .default
        tool.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        tool.setItems([space, doneButton], animated: false)
        tool.isUserInteractionEnabled = true
        tool.sizeToFit()
        return tool
    }()
    
    //MARK: - personal data
    lazy var personalLabel: UILabel = {
        let lable = UILabel()
        lable.text = "PERSONAL INFORMATION"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var dLicenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "DRIVER LICENSE"
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
        field.paddingRight(10)
        field.keyboardType = .default
        field.textColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5)
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
        field.paddingRight(10)
        field.keyboardType = .default
        field.textColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5)
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
        field.paddingRight(10)
        field.keyboardType = .emailAddress
        field.textColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5)
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
    let lableCc = Reusable.makeLabel(text: "+81", color: .black)
    
    lazy var phoneNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.keyboardType = .numberPad
        return field
    }()
    
    
    //MARK:- Driver icense number
    lazy var licenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "Driver License Number"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var license: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.keyboardType = .numberPad
        return field
    }()
    
    //MARK:- Driver icense Exp Date
    lazy var expDateLable: UILabel = {
        let lable = UILabel()
        lable.text = "License Expiration Date"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var datePickerExpiration: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(handleDatePickerEx), for: .valueChanged)
        date.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        date.timeZone = NSTimeZone.local
        date.backgroundColor = .white
            if #available(iOS 13.4, *) {
                date.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                // Fallback on earlier versions
            }
        return date
    }()
    
    @objc func handleDatePickerEx() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePickerExpiration.date)
        expDate.text = strDate
    }
    
    lazy var expDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.inputView = datePickerExpiration
        field.inputAccessoryView = toolBar
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        field.setRightViewIcon(icon: baru!)
        return field
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
        

        firstName.text = bio?.first_name
        lastName.text = bio?.last_name
        email.text = dataDriver?.email
        phoneNumber.text = bio?.phone_number
        license.text = bio?.driver_license_number
        expDate.text = bio?.driver_license_expiration_date
        ratingLabel.text = "\(dataDriver?.rating.avgRating ?? "0")"
        
        guard let totalRating: Double = Double((dataDriver?.rating.avgRating)!) else {
            print("konot;")
            
            return
        }
        
        if totalRating == 0 {
            rating1.image = UIImage(named: "star2")
            rating2.image = UIImage(named: "star2")
            rating3.image = UIImage(named: "star2")
            rating4.image = UIImage(named: "star2")
            rating5.image = UIImage(named: "star2")
        }
        
        if totalRating > 0  && totalRating >= 1 {
            rating1.image = UIImage(named: "star")
            rating2.image = UIImage(named: "star2")
            rating3.image = UIImage(named: "star2")
            rating4.image = UIImage(named: "star2")
            rating5.image = UIImage(named: "star2")
        }
        
        if (totalRating) > 1  && (totalRating) >= 2 {
            rating1.image = UIImage(named: "star")
            rating2.image = UIImage(named: "star")
            rating3.image = UIImage(named: "star2")
            rating4.image = UIImage(named: "star2")
            rating5.image = UIImage(named: "star2")
        }
        
        if (totalRating) > 2  && (totalRating) >= 3 {
            rating1.image = UIImage(named: "star")
            rating2.image = UIImage(named: "star")
            rating3.image = UIImage(named: "star")
            rating4.image = UIImage(named: "star2")
            rating5.image = UIImage(named: "star2")
        }
        
        if (totalRating) > 3  && (totalRating) >= 4 {
            rating1.image = UIImage(named: "star")
            rating2.image = UIImage(named: "star")
            rating3.image = UIImage(named: "star")
            rating4.image = UIImage(named: "star")
            rating5.image = UIImage(named: "star2")
        }
        
        if (totalRating) > 4  && (totalRating) >= 5 {
            rating1.image = UIImage(named: "star")
            rating2.image = UIImage(named: "star")
            rating3.image = UIImage(named: "star")
            rating4.image = UIImage(named: "star")
            rating5.image = UIImage(named: "star")
        }
        
        guard let photoUrl = bio?.photo_url, let photoName = bio?.photo_name else {
            return}
        if let urlString = URL(string: "\(photoUrl)\(photoName)") {
            let placeholderImage = UIImage(named: "personCircle")
            self.profilePhotoImage.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
        }
        
        if let date =  bio?.driver_license_expiration_date {
            let tanggal = Date.dateFromCustomString(customString: date)
            datePickerExpiration.date = tanggal
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstName.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
        lastName.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
        email.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
        phoneNumber.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
        license.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
        expDate.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerAutoKeyboard() { (result) in

        switch result.status {
        case .willShow:
        print("1")
        case .didShow:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
                self.stakView.heightAnchor.constraint(equalToConstant: 55*15).isActive = true
                let bottomOffset = CGPoint(x: 0, y: 250)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            })
        case .willHide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.stakView.heightAnchor.constraint(equalToConstant: 55*13).isActive = true
            })
        case .didHide:
            print("did hide")
        case .willChangeFrame:
            print("change")
        case .didChangeFrame:
            print("change2")
        }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterAutoKeyboard()
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
              let driverLicenseNumber = license.text,
              let driverExp = expDate.text,
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
    @objc func tapScV(){
        view.endEditing(true)
    }

    
    func configureLayout(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor,paddingTop: 16,paddingBottom: 16, paddingLeft: 16, paddingRight: 16,  height:(55*13))
        
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapScV)))
        
        stakView.addSubview(personalLabel)
        personalLabel.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        stakView.addSubview(profilePhotoImage)
        profilePhotoImage.anchor(top: personalLabel.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15, width: 80, height: 80)
        
        stakView.addSubview(firstNameLable)
        firstNameLable.anchor(top: profilePhotoImage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(firstName)
        firstName.anchor(top: firstNameLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(lastNameLable)
        lastNameLable.anchor(top: firstName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(lastName)
        lastName.anchor(top: lastNameLable.bottomAnchor,left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(emailLable)
        emailLable.anchor(top: lastName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(email)
        email.anchor(top: emailLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(phoneNumberLable)
        phoneNumberLable.anchor(top: email.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(phoneNumber)
        phoneNumber.anchor(top: phoneNumberLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(dLicenseLable)
        dLicenseLable.anchor(top: phoneNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 24)
        
        stakView.addSubview(licenseLable)
        licenseLable.anchor(top: dLicenseLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 16)
        
        stakView.addSubview(license)
        license.anchor(top: licenseLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(expDateLable)
        expDateLable.anchor(top: license.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 16)
        
        stakView.addSubview(expDate)
        expDate.anchor(top: expDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        //ratings
        stakView.addSubviews(views: rating1,rating2,rating3,rating4,rating5,ratingLabel)
        ratingLabel.anchor(left: profilePhotoImage.rightAnchor, paddingLeft: 10)
        rating1.anchor(left: ratingLabel.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating2.anchor(left: rating1.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating3.anchor(left: rating2.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating4.anchor(left: rating3.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        rating5.anchor(left: rating4.rightAnchor, paddingLeft: 10, width: 15, height: 15)
        
        [rating1,rating2,rating3,rating4,rating5,ratingLabel].forEach { (i) in
            i.centerYAnchor.constraint(equalTo: profilePhotoImage.centerYAnchor).isActive = true
        }
    
    }
    

    func configureNavigationBar(){
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(updateProfile))
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
    }
}
