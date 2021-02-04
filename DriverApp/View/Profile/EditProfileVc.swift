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
import LanguageManager_iOS

@available(iOS 13.0, *)
class EditProfileVc: UIViewController {
    
    var dataDriver: UserModel? = nil
    var bio: Bio? = nil
    var profileVm = ProfileViewModel()
    var editFoto: Bool = false
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
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
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(onClickDoneButton))
        tool.setItems([space, doneButton], animated: false)
        tool.isUserInteractionEnabled = true
        tool.sizeToFit()
        return tool
    }()
    
    //MARK: - personal data
    lazy var personalLabel: UILabel = {
        let lable = UILabel()
        lable.text = "PERSONAL INFORMATION".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var dLicenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "DRIVER LICENSE".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var profilePhotoImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 120/2
        img.backgroundColor = UIColor(named: "bgInput")
        return img
    }()
    
    

    //MARK: - Name
    lazy var firstNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "First Name".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "labelColor")
        return lable
    }()
    
    lazy var firstName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.paddingLeft(10)
        field.layer.cornerRadius = 5
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .default
        field.textColor = UIColor(named: "labelSecondary")
        field.isEnabled = false
        return field
    }()
    
    lazy var lastNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "Last Name".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "labelColor")
        return lable
    }()
    
    lazy var lastName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.paddingLeft(10)
        field.layer.cornerRadius = 5
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .default
        field.textColor = UIColor(named: "labelSecondary")
        field.isEnabled = false
        return field
    }()
    
    //MARK:- Email
    lazy var emailLable: UILabel = {
        let lable = UILabel()
        lable.text = "Email".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "labelColor")
        return lable
    }()
    
    lazy var email: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.paddingLeft(10)
        field.layer.cornerRadius = 5
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .emailAddress
        field.textColor = UIColor(named: "labelSecondary")
        field.isEnabled = false
        return field
    }()
    
    //MARK:- PhoneNumber
    lazy var phoneNumberLable: UILabel = {
        let lable = UILabel()
        lable.text = "Phone Number".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "labelColor")
        return lable
    }()
    let lableCc = Reusable.makeLabel(text: "+81", color: .black)
    
    lazy var phoneNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.paddingLeft(10)
        field.layer.cornerRadius = 5
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .numberPad
        return field
    }()
    
    
    //MARK:- Driver icense number
    lazy var licenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "Driver License Number".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "labelColor")
        return lable
    }()
    
    lazy var license: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.paddingLeft(10)
        field.layer.cornerRadius = 5
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .numberPad
        return field
    }()
    
    //MARK:- Driver icense Exp Date
    lazy var expDateLable: UILabel = {
        let lable = UILabel()
        lable.text = "License Expiration Date".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "labelColor")
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
        field.paddingLeft(10)
        field.layer.cornerRadius = 5
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = datePickerExpiration
        field.inputAccessoryView = toolBar
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        field.setRightViewIcon(icon: baru!)
        return field
    }()
    
    private let buttonEditFoto: UIView = {
       let view = UIView()
        let imageEditFoto = Reusable.makeImageView(image: UIImage(named: "editIcon")!, contentMode: .scaleAspectFit)
        view.backgroundColor = UIColor(named: "orangeKasumi")
        view.layer.cornerRadius = 30/2
        view.addSubview(imageEditFoto)
        view.translatesAutoresizingMaskIntoConstraints = false
        imageEditFoto.translatesAutoresizingMaskIntoConstraints = false
        imageEditFoto.height(15)
        imageEditFoto.width(15)
        imageEditFoto.center(toView: view)
        return view
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

        view.backgroundColor = UIColor(named: "whiteKasumi")
        configureNavigationBar()
        

        firstName.text = bio?.first_name
        lastName.text = bio?.last_name
        email.text = dataDriver?.email
        phoneNumber.text = bio?.phone_number
        license.text = bio?.driver_license_number
        expDate.text = bio?.driver_license_expiration_date
        
        buttonEditFoto.isUserInteractionEnabled = true
        buttonEditFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEditPhoto)))
        
        
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
            print("show")
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        case .willHide:
           print("hide")
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    @objc private func didTapEditPhoto(){
        presentPhotoActionSheet()
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
        
        let profilePhoto = !editFoto ? nil : Helpers().convertImageToBase64String(img: profilePhotoImage.image!)
        
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
                                                      photo: profilePhoto,
                                                      phone_number: phoneNumber)
        
        guard let bio: String = profileVm.encryptBio(data: personalData, codeDriver: dataDriver!.code_driver) else {return}
        
        let dataTopost: UpdatePersonal = UpdatePersonal(bio: bio, code_driver: dataDriver!.code_driver)
        
        let action = UIAlertAction(title: "Oke".localiz(), style: .default) { (_) in
            self.startsubmit(data: dataTopost)
        }
        let action2 = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message:"Continue to edit profile ?".localiz(), customTitle: "Are you sure ?".localiz(), customAction1: action, customAction2: action2)
    }
    
    
    private func startsubmit(data: UpdatePersonal){
        spiner.show(in: view)
        profileVm.updateProfile(data: data) { (res) in
            switch res {
            case .success(let oke):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    if oke {
                        let action = UIAlertAction(title: "Oke".localiz(), style: .default) { (_) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        Helpers().showAlert(view: self, message:"Success edit profile".localiz(), customTitle: "Success".localiz(), customAction1: action)
                    }
                }
            case .failure(let err):
                Helpers().showAlert(view: self, message: err.localizedDescription, customTitle: "Error".localiz())
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
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor,paddingTop: 16,paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapScV)))
        
        stakView.addSubview(personalLabel)
        personalLabel.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        stakView.addSubview(profilePhotoImage)
        profilePhotoImage.anchor(top: personalLabel.bottomAnchor, paddingTop: 15, width: 120, height: 120)
        profilePhotoImage.centerX(toAnchor: view.centerXAnchor)
        profilePhotoImage.isUserInteractionEnabled = true
        profilePhotoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEditPhoto)))
        stakView.addSubview(buttonEditFoto)
        buttonEditFoto.bottom(toAnchor: profilePhotoImage.bottomAnchor, space: -5)
        buttonEditFoto.right(toAnchor: profilePhotoImage.rightAnchor, space: -5)
        buttonEditFoto.height(30)
        buttonEditFoto.width(30)
        
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
        expDate.bottom(toAnchor: stakView.bottomAnchor, space: -20)
    
    }
    

    func configureNavigationBar(){
        navigationItem.title = "Edit Profile".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localiz(), style: .plain, target: self, action: #selector(updateProfile))
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
    }
}


@available(iOS 13.0, *)
extension EditProfileVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
func presentPhotoActionSheet(){
    let actionSheet = UIAlertController(title: "Profile Picture".localiz(),
                                        message: "How would you like to select a picture?".localiz(),
                                        preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Cancel".localiz(),
                                        style: .cancel,
                                        handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Take Photo".localiz(),
                                        style: .default,
                                        handler: { [weak self] _ in
                                            
                                            self?.presentCamera()
                                        }))
    actionSheet.addAction(UIAlertAction(title: "Choose Photo".localiz(),
                                        style: .default,
                                        handler: { [weak self] _ in
                                            self?.presetPhotoPicker()
                                        }))
    
    present(actionSheet, animated: true)
}

func presentCamera(){
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.delegate = self
    vc.allowsEditing = true
    present(vc,animated: true)
}

func presetPhotoPicker(){
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    present(vc,animated: true)
    
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print(picker)
    picker.dismiss(animated: true, completion: nil)
    guard let selectdedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
        return
    }
    
    
    let hasil = Helpers().resizeImageUpload(image: selectdedImage)
    profilePhotoImage.image = hasil
    editFoto = true
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
}
}
