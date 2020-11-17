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
        btn.addTarget(self, action: #selector(presentPhotoActionSheetProfile), for: .touchUpInside)
        
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
    
    
    //MARK: - Driver Lincense
    lazy var driverLicenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "DRIVER LICENSE"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var vehicleDataLable: UILabel = {
        let lable = UILabel()
        lable.text = "VEHICLE DATA"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    
    lazy var vehiclePhotoLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Photo"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var imageViewVehicle: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .lightGray
        return img
    }()
    
    
    lazy var containerSelectImage: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        return view
    }()
    
    //MARK:- License Number
    lazy var licenseNumberLable: UILabel = {
        let lable = UILabel()
        lable.text = "License Number"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var licenseNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "License Number"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- License Expiration Date
    lazy var licenseExpiretionDateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Driver's License Expiration Date"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var licenseExpiration: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Driver's License Expiration Date"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    
    //MARK:- Vehicle Data
    //MARK:- Insurance Company
    lazy var insuranceCompanyLable: UILabel = {
        let lable = UILabel()
        lable.text = "Insurance Company"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var insuranceCompany: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Insurance Company Name"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Personal Coverage
    lazy var personalCoverageLable: UILabel = {
        let lable = UILabel()
        lable.text = "Personal Coverage"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var personalCoverage: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Personal Coverage"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Compensation Range-Objective
    lazy var compensationLable: UILabel = {
        let lable = UILabel()
        lable.text = "Compensation Range-Objective"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var compensation: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Compensation Range-Objective"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Insurance Expiration Date
    lazy var insuranceExpirationDateLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Insurance Expiration Date"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var insuranceExpirationDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Insurance Expiration Date"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Name
    lazy var vehicleNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Name"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Name"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Type
    lazy var vehicleTypeLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Type"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleType: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Type"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Number Plate
    lazy var vehicleNumberPlateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Number Plate"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleNumberPlate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Number Plate"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Year
    lazy var vehicleYearLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Year"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleYear: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Year"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Vehicle Ownership
    lazy var vehicleOwnershipLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Ownership"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleOwnership: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Ownership"
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
        loginButton.setTitle("Finish Registration", for: .normal)
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
        scroll.bounces = true
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
        configureUiLicense()
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
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height:(55*20)+(55*23))

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

    }
    
    //    MARK: - Configuring UI Driver License
        private func configureUiLicense(){

            stakView.addSubview(driverLicenseLable)
            driverLicenseLable.anchor(top: kanaAfterAddress.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor,paddingTop: 15)
            
            stakView.addSubview(licenseNumberLable)
            licenseNumberLable.anchor(top: driverLicenseLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(licenseNumber)
            licenseNumber.anchor(top: licenseNumberLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(licenseExpiretionDateLable)
            licenseExpiretionDateLable.anchor(top: licenseNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(licenseExpiration)
            licenseExpiration.anchor(top: licenseExpiretionDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(vehicleDataLable)
            vehicleDataLable.anchor(top: licenseExpiration.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor,paddingTop: 15)
            
            stakView.addSubview(insuranceCompanyLable)
            insuranceCompanyLable.anchor(top: vehicleDataLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(insuranceCompany)
            insuranceCompany.anchor(top: insuranceCompanyLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(personalCoverageLable)
            personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(personalCoverage)
            personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(personalCoverageLable)
            personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(personalCoverage)
            personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)

            stakView.addSubview(compensationLable)
            compensationLable.anchor(top: personalCoverage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(compensation)
            compensation.anchor(top: compensationLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(insuranceExpirationDateLabel)
            insuranceExpirationDateLabel.anchor(top: compensation.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(insuranceExpirationDate)
            insuranceExpirationDate.anchor(top: insuranceExpirationDateLabel.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(vehicleNameLable)
            vehicleNameLable.anchor(top: insuranceExpirationDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleName)
            vehicleName.anchor(top: vehicleNameLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(vehicleTypeLable)
            vehicleTypeLable.anchor(top: vehicleName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleType)
            vehicleType.anchor(top: vehicleTypeLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(vehicleNumberPlateLable)
            vehicleNumberPlateLable.anchor(top: vehicleType.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleNumberPlate)
            vehicleNumberPlate.anchor(top: vehicleNumberPlateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)

            stakView.addSubview(vehicleYearLable)
            vehicleYearLable.anchor(top: vehicleNumberPlate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleYear)
            vehicleYear.anchor(top: vehicleYearLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(vehicleOwnershipLable)
            vehicleOwnershipLable.anchor(top: vehicleYear.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleOwnership)
            vehicleOwnership.anchor(top: vehicleOwnershipLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
            
            stakView.addSubview(vehiclePhotoLable)
            vehiclePhotoLable.anchor(top: vehicleOwnership.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(containerSelectImage)
            containerSelectImage.anchor(top: vehiclePhotoLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 200)
            
            stakView.addSubview(nextButton)
            nextButton.anchor(top: containerSelectImage.bottomAnchor, right: stakView.rightAnchor, paddingTop: 40, width: view.frame.width-32, height: 45)
        }
    
    
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
}


    //MARK: - EXTENSION

extension RegisterView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func presentPhotoActionSheetProfile(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Phote",
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
        
        let base64Img = convertImageToBase64String(img: selectdedImage)
        print(base64Img)
        
        self.imageView.image = selectdedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return "data:image/png;base64,\(img.jpegData(compressionQuality: 0.7)?.base64EncodedString() ?? "")"
    }
}

