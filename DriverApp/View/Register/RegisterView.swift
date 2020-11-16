//
//  RegisterView.swift
//  DriverApp
//
//  Created by Indo Office4 on 10/11/20.
//

import UIKit

class RegisterView: UIViewController {
    
    //MARK: - Component
    lazy var lableTitleRegister: UILabel = {
        let lable = UILabel()
        lable.text = "Register now"
        lable.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()

    lazy var subTableTitleRegister: UILabel = {
        let lable = UILabel()
        lable.text = "Register as freelance driver now"
        lable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var personalLabel: UILabel = {
        let lable = UILabel()
        lable.text = "PERSONAL INFORMATION"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var addressLable: UILabel = {
        let lable = UILabel()
        lable.text = "ADDRESS"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var profileFoto: UILabel = {
        let lable = UILabel()
        lable.text = "Profile Photo"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 80/2
        img.backgroundColor = .lightGray
        return img
    }()
    
    lazy var imgName: UILabel = {
        let lable = UILabel()
        lable.text = "Image name Lable"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var selecImage: UIButton = {
        let btn = UIButton()
        btn.setTitle("Select Image", for: .normal)
        btn.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        btn.setTitleColor(UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2), for: .highlighted)
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        return btn
    }()
    
    //MARK: - Name
    lazy var firstNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "First Name"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
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
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    lazy var lastNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "Last Name"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
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
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Email
    lazy var emailLable: UILabel = {
        let lable = UILabel()
        lable.text = "Email"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
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
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Password
    lazy var passwordLable: UILabel = {
        let lable = UILabel()
        lable.text = "Password"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Password"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.isSecureTextEntry = true
        return field
    }()
    
    //MARK:- Brith date
    lazy var brithDateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Email"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var brithDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "DD/MM/YYYY"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Gender
    lazy var genderLable: UILabel = {
        let lable = UILabel()
        lable.text = "Gender"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var gender: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Select Your Gender"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Language
    lazy var languageLable: UILabel = {
        let lable = UILabel()
        lable.text = "Language"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var language: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Select Your Language"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- PhoneNumber
    lazy var phoneNumberLable: UILabel = {
        let lable = UILabel()
        lable.text = "Phone Number"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var phoneNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "12121212"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Address
    ///Postal code
    lazy var postalCodeLable: UILabel = {
        let lable = UILabel()
        lable.text = "Postal Code"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var postalCode: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Postal Code"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    ///Prefectures
    lazy var prefecturesLable: UILabel = {
        let lable = UILabel()
        lable.text = "Prefectures"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var prefecture: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Prefectures"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    /// municipal district
    lazy var municipalLable: UILabel = {
        let lable = UILabel()
        lable.text = "Municipal District"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var municipal: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Municipal District"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    ///Chome
    lazy var chomeLable: UILabel = {
        let lable = UILabel()
        lable.text = "Chome"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var chome: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Chome"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    /// Municipality Kana
    lazy var municipalityKanaLable: UILabel = {
        let lable = UILabel()
        lable.text = "Municipality Kana"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var municipalityKana: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Municipality Kana"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    ///Kana After address
    lazy var kanaAfterAddressLable: UILabel = {
        let lable = UILabel()
        lable.text = "Kana After Address"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var kanaAfterAddress: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Kana After Address"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    
//   MARK: - Next button
    private let nextButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Next", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        loginButton.layer.cornerRadius = 2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        loginButton.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        return loginButton
    }()
    
    
    
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - Scroll View
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = false
        scroll.frame = self.view.bounds
        return scroll
    }()
    
    lazy var stakView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    //MARK:- lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUi()
    }
    
    //MARK: - FUNC
    @objc
    func onNext(){
        let vc = VehicleView()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Sign Up"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUi(){
        view.addSubview(scrollView)
//        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
        
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: view.frame.height+400)

        stakView.addSubview(lableTitleRegister)
        lableTitleRegister.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        stakView.addSubview(subTableTitleRegister)
        subTableTitleRegister.anchor(top: lableTitleRegister.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingRight: 0)
        
        stakView.addSubview(personalLabel)
        personalLabel.anchor(top: subTableTitleRegister.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingRight: 0)
        
        stakView.addSubview(profileFoto)
        profileFoto.anchor(top: personalLabel.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 10)
        
        stakView.addSubview(imageView)
        imageView.anchor(top: profileFoto.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: 80, height: 80)
        
        stakView.addSubview(imgName)
        imgName.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, right: stakView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        
        stakView.addSubview(selecImage)
        selecImage.anchor(left: imageView.rightAnchor, bottom: imageView.bottomAnchor, paddingBottom: 10, paddingLeft: 10, height: 30)
        
        stakView.addSubview(firstNameLable)
        firstNameLable.anchor(top: imageView.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(firstName)
        firstName.anchor(top: firstNameLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 2, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(lastNameLable)
        lastNameLable.anchor(top: imageView.bottomAnchor,left: firstNameLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(lastName)
        lastName.anchor(top: lastNameLable.bottomAnchor,left: firstName.rightAnchor, right: stakView.rightAnchor, paddingTop: 2,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(emailLable)
        emailLable.anchor(top: firstName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(email)
        email.anchor(top: emailLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(passwordLable)
        passwordLable.anchor(top: email.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(password)
        password.anchor(top: passwordLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(brithDateLable)
        brithDateLable.anchor(top: password.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(brithDate)
        brithDate.anchor(top: brithDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(genderLable)
        genderLable.anchor(top: brithDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(gender)
        gender.anchor(top: genderLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(languageLable)
        languageLable.anchor(top: gender.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(language)
        language.anchor(top: languageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(phoneNumberLable)
        phoneNumberLable.anchor(top: language.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(phoneNumber)
        phoneNumber.anchor(top: phoneNumberLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(addressLable)
        addressLable.anchor(top: phoneNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        
        stakView.addSubview(postalCodeLable)
        postalCodeLable.anchor(top: addressLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(postalCode)
        postalCode.anchor(top: postalCodeLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 2, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(prefecturesLable)
        prefecturesLable.anchor(top: addressLable.bottomAnchor,left: postalCodeLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(prefecture)
        prefecture.anchor(top: prefecturesLable.bottomAnchor,left: postalCode.rightAnchor, right: stakView.rightAnchor, paddingTop: 2,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        
        stakView.addSubview(municipalLable)
        municipalLable.anchor(top: postalCode.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(municipal)
        municipal.anchor(top: municipalLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 2, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(chomeLable)
        chomeLable.anchor(top: prefecture.bottomAnchor,left: municipalLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(chome)
        chome.anchor(top: chomeLable.bottomAnchor,left: municipal.rightAnchor, right: stakView.rightAnchor, paddingTop: 2,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(municipalityKanaLable)
        municipalityKanaLable.anchor(top: municipal.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(municipalityKana)
        municipalityKana.anchor(top: municipalityKanaLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 2, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(kanaAfterAddressLable)
        kanaAfterAddressLable.anchor(top: chome.bottomAnchor,left: municipalityKanaLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(kanaAfterAddress)
        kanaAfterAddress.anchor(top: kanaAfterAddressLable.bottomAnchor,left: municipalityKana.rightAnchor, right: stakView.rightAnchor, paddingTop: 2,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(nextButton)
        nextButton.anchor(top: kanaAfterAddress.bottomAnchor, right: stakView.rightAnchor, paddingTop: 40, width: view.frame.width/3-16, height: 45)

    }
    
    
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
}


    //MARK: - EXTENSION

extension RegisterView{
    
}
