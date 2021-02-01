//
//  RegisterView.swift
//  DriverApp
//
//  Created by Indo Office4 on 10/11/20.
//

import UIKit
import JGProgressHUD
import LanguageManager_iOS

@available(iOS 13.0, *)
class RegisterView: UIViewController {
    
    var pop = PopUpView()
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    var registerVm = RegisterViewModel()
    
    //MARK: - variable
    let genders:[Gender] = [
        Gender(name: "Male".localiz()),
        Gender(name: "Female".localiz())
    ]
    
    let languages:[Language] = [
        Language(name: "JP".localiz()),
        Language(name: "EN".localiz())
    ]
    
    var vehicleY = [VehicleYear]()
    
    var selectedImageView: UIImageView?

    
    //MARK: - Component
    lazy var lableTitleRegister: UILabel = {
        let lable = UILabel()
        lable.text = "Register as a freelance driver".localiz()
        lable.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lable.textColor = UIColor(named: "orangeKasumi")
        lable.numberOfLines = 0
        return lable
    }()

    
    lazy var personalLabel: UILabel = {
        let lable = UILabel()
        lable.text = "PERSONAL INFORMATION".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var addressLable: UILabel = {
        let lable = UILabel()
        lable.text = "ADDRESS".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    //MARK: - Profile photo
    
    lazy var profilePhotoDumy: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "personCircle")
        img.clipsToBounds = true
        return img
    }()
    
    lazy var profilePhotoImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 80/2
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfilePhoto)))
        img.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        return img
    }()

    
    let lableColor: UIColor = .black
    let lablefont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    let inputBg: UIColor = UIColor(named: "bgInput")!
    
    //MARK: - Lable
    lazy var profilePhotoLable = Reusable.makeLabel(text: "Profile Photo".localiz(),font: lablefont, color: lableColor, alignment: .center)
    lazy var firstNameLable = Reusable.makeLabel(text: "First Name".localiz(),font: lablefont, color: lableColor)
    lazy var lastNameLable = Reusable.makeLabel(text: "Last Name".localiz(),font: lablefont, color: lableColor)
    lazy var firstNameHiraganaLable = Reusable.makeLabel(text: "First Name Hiragana".localiz(),font: lablefont, color: lableColor)
    lazy var lastNameHiraganaLable = Reusable.makeLabel(text: "Last Name Hiragana".localiz(),font: lablefont, color: lableColor)
    lazy var emailLable = Reusable.makeLabel(text: "Email".localiz(),font: lablefont, color: lableColor)
    lazy var passwordLable = Reusable.makeLabel(text: "Password".localiz(),font: lablefont, color: lableColor)
    lazy var brithDateLable = Reusable.makeLabel(text: "Date Of Birth".localiz(),font: lablefont, color: lableColor)
    lazy var genderLable = Reusable.makeLabel(text: "Gender".localiz(),font: lablefont, color: lableColor)
    lazy var languageLable = Reusable.makeLabel(text: "Language".localiz(),font: lablefont, color: lableColor)
    lazy var phoneNumberLable = Reusable.makeLabel(text: "Phone Number".localiz(),font: lablefont, color: lableColor)
    lazy var postalCodeLable = Reusable.makeLabel(text: "Postal Code".localiz(),font: lablefont, color: lableColor)
    lazy var prefecturesLable = Reusable.makeLabel(text: "Prefectures".localiz(),font: lablefont, color: lableColor)
    lazy var municipalLable = Reusable.makeLabel(text: "Municipal District".localiz(),font: lablefont, color: lableColor)
    lazy var chomeLable = Reusable.makeLabel(text: "Chome".localiz(),font: lablefont, color: lableColor)
    lazy var municipalityKanaLable = Reusable.makeLabel(text: "Municipality Kana".localiz(),font: lablefont, color: lableColor)
    lazy var kanaAfterAddressLable = Reusable.makeLabel(text: "Kana After Address".localiz(),font: lablefont, color: lableColor)
    lazy var vehiclePhotoLable = Reusable.makeLabel(text: "Vehicle Inspection Certificate Photo".localiz(),font: lablefont, color: lableColor)
    lazy var vehiclePhotoLable2 = Reusable.makeLabel(text: "Vehicle Photo".localiz(),font: lablefont, color: lableColor)
    lazy var licenseExpiretionDateLable = Reusable.makeLabel(text: "Driver's License Expiration Date".localiz(), color: lableColor)
    lazy var insuranceCompanyLable = Reusable.makeLabel(text: "Insurance Company".localiz(),font: lablefont, color: lableColor)
    lazy var personalCoverageLable = Reusable.makeLabel(text: "Personal Coverage".localiz(),font: lablefont, color: lableColor)
    lazy var compensationLable = Reusable.makeLabel(text: "Compensation Range-Objective".localiz(),font: lablefont, color: lableColor)
    lazy var insuranceExpirationDateLabel = Reusable.makeLabel(text: "Insurance Expiration Date".localiz(),font: lablefont, color: lableColor)
    lazy var vehicleNameLable =  Reusable.makeLabel(text: "Vehicle Name".localiz(),font: lablefont, color: lableColor)
    lazy var vehicleNumberPlateLable =  Reusable.makeLabel(text: "Vehicle Number Plate".localiz(),font: lablefont, color: lableColor)
    lazy var vehicleYearLable =  Reusable.makeLabel(text: "Vehicle Year".localiz(),font: lablefont, color: lableColor)
    lazy var vehicleOwnershipLable =  Reusable.makeLabel(text: "Vehicle Ownership".localiz(),font: lablefont, color: lableColor)
    lazy var vehicleInspectionExpDateLable =  Reusable.makeLabel(text: "Vehicle Inspection Exp. Date".localiz(),font: lablefont, color: lableColor)
    lazy var licenseNumberLable = Reusable.makeLabel(text: "License Number".localiz(),font: lablefont, color: lableColor)
 

    
    //MARK: - Input Text
    lazy var firstName = Reusable.makeInput(placeholder: "First Name".localiz(), bg: inputBg, radius: 5, autoKapital: .none)
    lazy var lastName = Reusable.makeInput(placeholder: "Last Name".localiz(), bg: inputBg, radius: 5, autoKapital: .none)
    
    lazy var firstNameHiragana = Reusable.makeInput(placeholder: "First Name Hiragana".localiz(), bg: inputBg, radius: 5, autoKapital: .none)
    lazy var lastNameHiragana = Reusable.makeInput(placeholder: "Last Name Hiragana".localiz(), bg: inputBg, radius: 5, autoKapital: .none)
    
    //MARK: - Input Select
    
    //MARK: - Input Date
    
    //MARK: - Input Email
    lazy var email = Reusable.makeInput(placeholder: "Email".localiz(), keyType: .emailAddress, bg: inputBg, radius: 5, autoKapital: .none)
    
    //MARK: - Input Number
    
    //MARK: - Input Password
    lazy var password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Password".localiz()
        field.paddingLeft(10)
        let button = UIButton(type: .custom)
        let image = UIImage(named: "eyeIcon1")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(passwordShow), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    @objc func passwordShow(_ sender: UIButton){
        let image = UIImage(named: "eyeIcon1")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let image2 = UIImage(named: "eyeIcon2")
        let baru2 = image2?.resizeImage(CGSize(width: 20, height: 20))
        
        if password.isSecureTextEntry == true {
            password.isSecureTextEntry = false
            sender.setImage(baru2, for: .normal)
        }else {
            password.isSecureTextEntry = true
            sender.setImage(baru, for: .normal)
        }
    }
    
    //MARK:- Brith date
    
    lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
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
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        brithDate.text = strDate
    }

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
    
    lazy var brithDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "YYYY-MM-DD"
        
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(penDob), for: .touchUpInside)
        
        field.rightView = button
        field.rightViewMode = .always
        field.paddingLeft(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = datePicker
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func penDob(){
        brithDate.becomeFirstResponder()
    }
    
    //MARK:- Gender
    
    lazy var pickerView1: UIPickerView = {
        let pik = UIPickerView()
        
        return pik
    }()
    
    lazy var gender: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Select Your Gender".localiz()
        field.paddingLeft(10)
        
        let image = UIImage(named: "arrowDownIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(openGender), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = pickerView1
        field.inputAccessoryView = toolBar
        return field
    }()

    @objc private func openGender(){
        gender.becomeFirstResponder()
    }
    
    
    //MARK:- Language
    
    lazy var pickerView2: UIPickerView = {
        let pik = UIPickerView()
        
        return pik
    }()
    
    lazy var language: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Select Your Language".localiz()
        field.paddingLeft(10)
        
        let image = UIImage(named: "arrowDownIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(openLan), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = pickerView2
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func openLan(){
        language.becomeFirstResponder()
    }
    
    //MARK:- PhoneNumber
    
    lazy var viewCc: UIView = {
        let v = UIView()
        let lableCC = Reusable.makeLabel(text: "+81", font: lablefont, color: lableColor, alignment: .center)
        v.addSubview(lableCC)
        lableCC.translatesAutoresizingMaskIntoConstraints = false
        lableCC.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        lableCC.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        v.backgroundColor = inputBg
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var phoneNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "123456"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .numberPad
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK: - Address
    ///Postal code
  
    lazy var postalCode: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Postal Code".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.keyboardType = .numberPad
        field.returnKeyType = .continue
        return field
    }()
    
    ///Prefectures
 
    
    lazy var prefecture: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Prefectures".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    /// municipal district
   
    
    lazy var municipal: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Municipal District".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    ///Chome
   
    
    lazy var chome: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Chome".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    /// Municipality Kana
    
    
    lazy var municipalityKana: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Municipality Kana".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    ///Kana After address
    lazy var kanaAfterAddress: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Kana After Address".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    
    //MARK: - Driver Lincense
    lazy var driverLicenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "DRIVER LICENSE".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    //MARK:- vehicleDataLable
    lazy var vehicleDataLable: UILabel = {
        let lable = UILabel()
        lable.text = "VEHICLE DATA".localiz()
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    
  
    
    //MARK:- vehicleCertifiateImage
    lazy var vehicleCertifiateImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 4
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVCI)))
        return img
    }()
    
    @objc
    func selectVCI(){
        selectedImageView = vehicleCertifiateImage
        presentPhotoActionSheet()
    }
    
    //MARK:- containerSelectImage
    lazy var containerSelectImage: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "bgInput")
        return view
    }()
    
    //MARK:- License Number
    
    lazy var licenseNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "License Number".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        field.keyboardType = .numberPad
        return field
    }()
    
    //MARK:- License Expiration Date
    
    
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
        licenseExpiration.text = strDate
    }
    
    lazy var licenseExpiration: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 3
        field.placeholder = "Driver's License Expiration Date".localiz()
        field.paddingLeft(10)
        
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(openLicenseDate), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = datePickerExpiration
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func openLicenseDate(){
        licenseExpiration.becomeFirstResponder()
    }
    
    
    //MARK:- Vehicle Data
    //MARK:- Insurance Company
    
    
    lazy var insuranceCompany: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Insurance Company Name".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Personal Coverage
    
    
    lazy var personalCoverage: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Personal Coverage".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Compensation Range-Objective
    
   
    
    lazy var compensation: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Compensation Range-Objective".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Insurance Expiration Date
   
    
    lazy var datePickerInsurance: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(handleDatePickerInsurance), for: .valueChanged)
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
    
    @objc func handleDatePickerInsurance() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePickerInsurance.date)
        insuranceExpirationDate.text = strDate
    }
    
    lazy var insuranceExpirationDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Insurance Expiration Date".localiz()
        field.paddingLeft(10)
        
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(openInsurance), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = datePickerInsurance
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func openInsurance(){
        insuranceExpirationDate.becomeFirstResponder()
    }
    
    //MARK: - Vehicle Name
    
    
    lazy var vehicleName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Vehicle Name".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    
    //MARK: - Vehicle Number Plate
    
    
    lazy var vehicleNumberPlate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Vehicle Number Plate".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK: - Vehicle Year
    
    
    lazy var pickerView3: UIPickerView = {
        let pik = UIPickerView()
        
        return pik
    }()
    
    lazy var vehicleYear: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Vehicle Year".localiz()
        field.paddingLeft(10)
        
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(openVehicleYear), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = pickerView3
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func openVehicleYear(){
        vehicleYear.becomeFirstResponder()
    }
    
    //MARK:- Vehicle Ownership
    
    
    lazy var vehicleOwnership: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Vehicle Ownership".localiz()
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = UIColor(named: "bgInput")
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Vehicle Inspection Exp. Date
    
    
    lazy var datePickerInspection: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(handleDatePickerInspection), for: .valueChanged)
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
    
    @objc func handleDatePickerInspection() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePickerInspection.date)
        vehicleInspectionExpDate.text = strDate
    }
    
    lazy var vehicleInspectionExpDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Insurance Expiration Date".localiz()
        field.paddingLeft(10)
        
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        let button = UIButton(type: .custom)
        button.setImage(baru, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(field.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(openExp), for: .touchUpInside)
        field.rightView = button
        field.rightViewMode = .always
        field.backgroundColor = UIColor(named: "bgInput")
        field.inputView = datePickerInspection
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc private func openExp(){
        vehicleInspectionExpDate.becomeFirstResponder()
    }
    
    
//   MARK: - Next button
    private let nextButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Finish Registration".localiz(), for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        loginButton.layer.cornerRadius = 2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        loginButton.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        return loginButton
    }()
    
    //MARK: - Vehicle Photo
    lazy var containerPhoto: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
//        view.backgroundColor = .red
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    func createView()-> UIView{
       let viewC = UIView()
        let lable = UILabel()
        let img = UIImageView()
        img.image = UIImage(named: "cameraIcon2")
        lable.text = "Upload Photo".localiz()
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5)
        lable.textAlignment = .center
        viewC.addSubview(lable)
        viewC.addSubview(img)
        img.anchor(top: viewC.topAnchor, width: 30, height: 30)
        img.centerXAnchor.constraint(equalTo: viewC.centerXAnchor).isActive = true
        lable.anchor(top: img.bottomAnchor, left: viewC.leftAnchor, right: viewC.rightAnchor, paddingTop: 5)
       return viewC
    }
    
    lazy var vehicleImage1: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.backgroundColor = UIColor(named: "bgInput")
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVI1)))
        return img
    }()
    
    @objc
    func selectVI1(){
        selectedImageView = vehicleImage1
        presentPhotoActionSheet()
        view.endEditing(true)
    }
    
    lazy var vehicleImage2: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.backgroundColor = UIColor(named: "bgInput")
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVI2)))
        return img
    }()
    
    @objc
    func selectVI2(){
        selectedImageView = vehicleImage2
        presentPhotoActionSheet()
        view.endEditing(true)
    }
    
    lazy var vehicleImage3: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.backgroundColor = UIColor(named: "bgInput")
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVI3)))
        return img
    }()
    
    @objc
    func selectVI3(){
        selectedImageView = vehicleImage3
        presentPhotoActionSheet()
        view.endEditing(true)
    }
    
//    MARK:- dummy
    lazy var dumyC = createView()
    lazy var dumy1 = createView()
    lazy var dumy2 = createView()
    lazy var dumy3 = createView()
    
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - Scroll View
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        scroll.frame = self.view.bounds
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return scroll
    }()
    
    lazy var stakView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    //MARK:- lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        pickerView2.delegate = self
        pickerView2.dataSource = self

        pickerView3.delegate = self
        pickerView3.dataSource = self
        
        password.isSecureTextEntry = true

        
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let formattedDate = format.string(from: Date())
        
        for i in (2000..<Int(formattedDate)!+20).reversed() {
            vehicleY.append(VehicleYear(year: String(i)))
        }
        
        view.backgroundColor = .white
        configureNavigationBar()
        
        
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))

        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))

        //We make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
        firstName.becomeFirstResponder()
        
        //dummy
        
//        firstName.text = "First"
//        lastName.text = "Last"
//        firstNameHiragana.text = "Hira"
//              lastNameHiragana.text = "Gana"
//              brithDate.text = "15-05-2000"
//              postalCode.text = "1243"
//              prefecture.text = "Prefecture"
//              municipal.text = "municipal"
//              chome.text = "Come"
//              municipalityKana.text = "muniKana"
//              kanaAfterAddress.text = "Kana afterAddress"
//              gender.text = "Male"
//              phoneNumber.text = "123123123"
//              email.text = "email@gmail.com"
//              password.text = "123"
//              licenseNumber.text = "12321"
//              licenseExpiration.text = "2020"
//              insuranceCompany.text = "234234"
//              personalCoverage.text = "232"
//              compensation.text = "214234"
//              insuranceExpirationDate.text = "15-05-2030"
//              vehicleName.text = "234234"
//              vehicleNumberPlate.text = "23424"
//              vehicleYear.text = "2022"
//              vehicleOwnership.text = "234234"
//              vehicleInspectionExpDate.text = "15-05-2030"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUi()
        configureUiLicense()
    }
    
    //MARK: - FUNC
    
    private func configureNavigationBar(){
        navigationItem.title = "Registration".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back".localiz(), style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUi(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)

        stakView.addSubview(lableTitleRegister)
        lableTitleRegister.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)

        stakView.addSubview(personalLabel)
        personalLabel.anchor(top: lableTitleRegister.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingRight: 0)

        
        stakView.addSubview(profilePhotoImage)
        profilePhotoImage.anchor(top: personalLabel.bottomAnchor, paddingTop: 20, width: 80, height: 80)
        profilePhotoImage.centerXAnchor.constraint(equalTo: stakView.centerXAnchor).isActive = true
        
        profilePhotoImage.addSubview(profilePhotoDumy)
        profilePhotoDumy.anchor(width: 40, height: 40)
        profilePhotoDumy.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoDumy.centerYAnchor.constraint(equalTo: profilePhotoImage.centerYAnchor).isActive = true
        profilePhotoDumy.centerXAnchor.constraint(equalTo: profilePhotoImage.centerXAnchor).isActive = true
        
        stakView.addSubview(profilePhotoLable)
        profilePhotoLable.anchor(top: profilePhotoImage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 10)
        
        stakView.addSubview(firstNameLable)
        firstNameLable.anchor(top: profilePhotoLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 20,width: view.frame.width/2-20)
        stakView.addSubview(firstName)
        firstName.anchor(top: firstNameLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(lastNameLable)
        lastNameLable.anchor(top: profilePhotoLable.bottomAnchor,left: firstNameLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 20,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(lastName)
        lastName.anchor(top: lastNameLable.bottomAnchor,left: firstName.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(firstNameHiraganaLable)
        firstNameHiraganaLable.anchor(top: firstName.bottomAnchor, left: stakView.leftAnchor, paddingTop: 20,width: view.frame.width/2-20)
        stakView.addSubview(firstNameHiragana)
        firstNameHiragana.anchor(top: firstNameHiraganaLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(lastNameHiraganaLable)
        lastNameHiraganaLable.anchor(top: lastName.bottomAnchor,left: firstNameHiraganaLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 20,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(lastNameHiragana)
        lastNameHiragana.anchor(top: lastNameHiraganaLable.bottomAnchor,left: firstName.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(brithDateLable)
        brithDateLable.anchor(top: firstNameHiragana.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(brithDate)
        brithDate.anchor(top: brithDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(addressLable)
        addressLable.anchor(top: brithDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        
        
        //MARK: - Addresss input
        stakView.addSubview(postalCodeLable)
        postalCodeLable.anchor(top: addressLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(postalCode)
        postalCode.anchor(top: postalCodeLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(prefecturesLable)
        prefecturesLable.anchor(top: addressLable.bottomAnchor,left: postalCodeLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(prefecture)
        prefecture.anchor(top: prefecturesLable.bottomAnchor,left: postalCode.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        
        stakView.addSubview(municipalLable)
        municipalLable.anchor(top: postalCode.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(municipal)
        municipal.anchor(top: municipalLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(chomeLable)
        chomeLable.anchor(top: prefecture.bottomAnchor,left: municipalLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(chome)
        chome.anchor(top: chomeLable.bottomAnchor,left: municipal.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(municipalityKanaLable)
        municipalityKanaLable.anchor(top: municipal.bottomAnchor, left: stakView.leftAnchor, paddingTop: 15,width: view.frame.width/2-20)
        stakView.addSubview(municipalityKana)
        municipalityKana.anchor(top: municipalityKanaLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: view.frame.width/2-20, height: 45)
        
        stakView.addSubview(kanaAfterAddressLable)
        kanaAfterAddressLable.anchor(top: chome.bottomAnchor,left: municipalityKanaLable.rightAnchor, right: stakView.rightAnchor, paddingTop: 15,paddingLeft: 8, width: view.frame.width/2-20)
        stakView.addSubview(kanaAfterAddress)
        kanaAfterAddress.anchor(top: kanaAfterAddressLable.bottomAnchor,left: municipalityKana.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 8, width: view.frame.width/2-20, height: 45)
        
        //MARK:- general information
        stakView.addSubview(genderLable)
        genderLable.anchor(top: kanaAfterAddress.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(gender)
        gender.anchor(top: genderLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
//        stakView.addSubview(languageLable)
//        languageLable.anchor(top: gender.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
//        stakView.addSubview(language)
//        language.anchor(top: languageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(phoneNumberLable)
        phoneNumberLable.anchor(top: gender.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        
        stakView.addSubview(viewCc)
        viewCc.anchor(top: phoneNumberLable.bottomAnchor, left: stakView.leftAnchor, paddingTop: 5, width: 100, height: 45)
        
        stakView.addSubview(phoneNumber)
        phoneNumber.anchor(top: phoneNumberLable.bottomAnchor, left: viewCc.rightAnchor, right: stakView.rightAnchor, paddingTop: 5,paddingLeft: 10, height: 45)
        
        stakView.addSubview(emailLable)
        emailLable.anchor(top: phoneNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(email)
        email.anchor(top: emailLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(passwordLable)
        passwordLable.anchor(top: email.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(password)
        password.anchor(top: passwordLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)

    }
    
    //    MARK: - Configuring UI Driver License
        private func configureUiLicense(){

            stakView.addSubview(driverLicenseLable)
            driverLicenseLable.anchor(top: password.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor,paddingTop: 15)
            
            stakView.addSubview(licenseNumberLable)
            licenseNumberLable.anchor(top: driverLicenseLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(licenseNumber)
            licenseNumber.anchor(top: licenseNumberLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(licenseExpiretionDateLable)
            licenseExpiretionDateLable.anchor(top: licenseNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(licenseExpiration)
            licenseExpiration.anchor(top: licenseExpiretionDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(vehicleDataLable)
            vehicleDataLable.anchor(top: licenseExpiration.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor,paddingTop: 15)
            
            stakView.addSubview(insuranceCompanyLable)
            insuranceCompanyLable.anchor(top: vehicleDataLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(insuranceCompany)
            insuranceCompany.anchor(top: insuranceCompanyLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(personalCoverageLable)
            personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(personalCoverage)
            personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(personalCoverageLable)
            personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(personalCoverage)
            personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)

            stakView.addSubview(compensationLable)
            compensationLable.anchor(top: personalCoverage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(compensation)
            compensation.anchor(top: compensationLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(insuranceExpirationDateLabel)
            insuranceExpirationDateLabel.anchor(top: compensation.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(insuranceExpirationDate)
            insuranceExpirationDate.anchor(top: insuranceExpirationDateLabel.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(vehicleNameLable)
            vehicleNameLable.anchor(top: insuranceExpirationDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleName)
            vehicleName.anchor(top: vehicleNameLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
//            stakView.addSubview(vehicleTypeLable)
//            vehicleTypeLable.anchor(top: vehicleName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
//            stakView.addSubview(vehicleType)
//            vehicleType.anchor(top: vehicleTypeLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(vehicleNumberPlateLable)
            vehicleNumberPlateLable.anchor(top: vehicleName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleNumberPlate)
            vehicleNumberPlate.anchor(top: vehicleNumberPlateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)

            stakView.addSubview(vehicleYearLable)
            vehicleYearLable.anchor(top: vehicleNumberPlate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleYear)
            vehicleYear.anchor(top: vehicleYearLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(vehicleOwnershipLable)
            vehicleOwnershipLable.anchor(top: vehicleYear.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleOwnership)
            vehicleOwnership.anchor(top: vehicleOwnershipLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(vehicleInspectionExpDateLable)
            vehicleInspectionExpDateLable.anchor(top: vehicleOwnership.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(vehicleInspectionExpDate)
            vehicleInspectionExpDate.anchor(top: vehicleInspectionExpDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
            
            stakView.addSubview(vehiclePhotoLable)
            vehiclePhotoLable.anchor(top: vehicleInspectionExpDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(containerSelectImage)
            containerSelectImage.anchor(top: vehiclePhotoLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 150)
            containerSelectImage.addSubview(vehicleCertifiateImage)
            vehicleCertifiateImage.anchor(top: containerSelectImage.topAnchor, left: containerSelectImage.leftAnchor, bottom: containerSelectImage.bottomAnchor, right: containerSelectImage.rightAnchor)
            
            
            vehicleCertifiateImage.addSubview(dumyC)
            dumyC.anchor(width: 100, height: 50)
            dumyC.centerYAnchor.constraint(equalTo: vehicleCertifiateImage.centerYAnchor).isActive = true
            dumyC.centerXAnchor.constraint(equalTo: vehicleCertifiateImage.centerXAnchor).isActive = true
            
            stakView.addSubview(vehiclePhotoLable2)
            vehiclePhotoLable2.anchor(top: containerSelectImage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
            stakView.addSubview(containerPhoto)
            containerPhoto.anchor(top: vehiclePhotoLable2.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 70)
            
            containerPhoto.addArrangedSubview(vehicleImage1)
            vehicleImage1.anchor(top: containerPhoto.topAnchor, bottom: containerPhoto.bottomAnchor)
            containerPhoto.addArrangedSubview(vehicleImage2)
            containerPhoto.addArrangedSubview(vehicleImage3)
            
            stakView.addSubview(nextButton)
            nextButton.anchor(top: containerPhoto.bottomAnchor, right: stakView.rightAnchor, paddingTop: 40, width: view.frame.width-32, height: 45)
            nextButton.bottom(toAnchor: stakView.bottomAnchor, space: -20)
            
            vehicleImage2.addSubview(dumy2)
            dumy2.anchor(width: 100, height: 50)
            dumy2.centerYAnchor.constraint(equalTo: vehicleImage2.centerYAnchor).isActive = true
            dumy2.centerXAnchor.constraint(equalTo: vehicleImage2.centerXAnchor).isActive = true
            
            vehicleImage1.addSubview(dumy1)
            dumy1.anchor(width: 100, height: 50)
            dumy1.centerYAnchor.constraint(equalTo: vehicleImage1.centerYAnchor).isActive = true
            dumy1.centerXAnchor.constraint(equalTo: vehicleImage1.centerXAnchor).isActive = true
            
            vehicleImage3.addSubview(dumy3)
            dumy3.anchor(width: 100, height: 50)
            dumy3.centerYAnchor.constraint(equalTo: vehicleImage3.centerYAnchor).isActive = true
            dumy3.centerXAnchor.constraint(equalTo: vehicleImage3.centerXAnchor).isActive = true
        }
    
    
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
}


    //MARK: - EXTENSION

@available(iOS 13.0, *)
extension RegisterView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func selectProfilePhoto(){
        selectedImageView = profilePhotoImage
        presentPhotoActionSheet()
        view.endEditing(true)
    }
    
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Select Photo".localiz(),
                                            message: "How would you like to select a picture ?".localiz(),
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
        picker.dismiss(animated: true, completion: nil)
        guard let selectdedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        
        let hasil = Helpers().resizeImageUpload(image: selectdedImage)
        selectedImageView?.image = hasil
//
//        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//            let fileName = url.lastPathComponent
//
//            if selectedImageView == profilePhotoImage {
//                imgName.text = fileName
//            }
//        }
        
        if selectedImageView == profilePhotoImage {
            profilePhotoDumy.isHidden = true
        }else if selectedImageView == vehicleCertifiateImage {
            dumyC.isHidden = true
        }else if selectedImageView == vehicleImage1 {
            dumy1.isHidden = true
        }else if selectedImageView == vehicleImage2 {
            dumy2.isHidden = true
        }else if selectedImageView == vehicleImage3 {
            dumy3.isHidden = true
        }else {
            print("not devined")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.view.endEditing(true)
            self.vehicleInspectionExpDate.resignFirstResponder()
        }
    }
}


@available(iOS 13.0, *)
extension RegisterView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return genders.count
        }
        else if pickerView == pickerView3 {
            return vehicleY.count
        }
        else {
            return languages.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return genders[row].name
        }
        else if pickerView == pickerView3 {
            return vehicleY[row].year
        }
        else {
            return languages[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            gender.text = genders[row].name
        }
        else if pickerView == pickerView3 {
            vehicleYear.text = vehicleY[row].year
        }
        else {
            language.text = languages[row].name
        }
    }
}


//MARK: - NEXT

@available(iOS 13.0, *)
extension RegisterView {
    @objc
    func onNext(){
        
        guard let userImgTemp = self.profilePhotoImage.image else {
            Helpers().showAlert(view: self, message: "Profile photo must be entered !".localiz())
            return}
        
        
        guard let firstName = self.firstName.text,
              let lastName = self.lastName.text,
              let firstNameHiragana = self.firstNameHiragana.text,
              let lastNameHiragana = self.lastNameHiragana.text,
              let dateOfBirth = self.brithDate.text,
              let postalCode = self.postalCode.text,
              let prefectures = self.prefecture.text,
              let municipalDis = self.municipal.text,
              let chome = self.chome.text,
              let municKana = self.municipalityKana.text,
              let kanaAfterAddress = self.kanaAfterAddress.text,
              let gender = self.gender.text,
              let phoneNumber = self.phoneNumber.text,
              let email = self.email.text,
              let password = self.password.text,
              let licenseNumber = self.licenseNumber.text,
              let licenseExpDate = self.licenseExpiration.text,
              let insuranceCom = self.insuranceCompany.text,
              let personalCov = self.personalCoverage.text,
              let comRangeObj = self.compensation.text,
              let insuranceExpDate = self.insuranceExpirationDate.text,
              let vName = self.vehicleName.text,
              let vPlate = self.vehicleNumberPlate.text,
              let vYear = self.vehicleYear.text,
              let vOwner = self.vehicleOwnership.text,
              let vCerExp = self.vehicleInspectionExpDate.text else {
            
            print("Masih ada yang kosong")
            return
        }
        
        
        
        let data: RegisterDataTemp = RegisterDataTemp(first_name: firstName,
                                                      last_name: lastName,
                                                      first_name_hiragana: firstNameHiragana,
                                                      last_name_hiragana: lastNameHiragana,
                                                      date_of_birth: dateOfBirth,
                                                      postal_code: postalCode,
                                                      prefectures: prefectures,
                                                      municipal_district: municipalDis,
                                                      chome: chome,
                                                      municipality_kana: municKana,
                                                      kana_after_address: kanaAfterAddress,
                                                      gender: gender.lowercased(),
                                                      language: "jp",
                                                      phone_number: phoneNumber,
                                                      email: email,
                                                      password: password,
                                                      license_number: licenseNumber,
                                                      license_expired_date: licenseExpDate,
                                                      insurance_company: insuranceCom,
                                                      personal_coverage: personalCov,
                                                      compensation_range_object: comRangeObj,
                                                      insurance_expired_date: insuranceExpDate,
                                                      vehicle_name: vName,
                                                      vehicle_number_plate: vPlate,
                                                      vehicle_year: vYear,
                                                      vehicle_ownership: vOwner,
                                                      vehicle_certificate_exp: vCerExp)
        
        registerVm.cekValidation(data: data) { (res) in
            switch res {
            case.failure(let err):
                Helpers().showAlert(view: self, message: err.localizedDescription)
                return
            case .success(let oke):
                if oke == true {
                    print("Next Save")
                }
            }
        }
        
        
        
        guard let vCerPhotoTemp = self.vehicleCertifiateImage.image else {
            Helpers().showAlert(view: self, message: "Vehicle certification photo must be entered !".localiz())
            return}
        
        guard let vPhotoTemp1 = self.vehicleImage1.image,
              let vPhotoTemp2 = self.vehicleImage2.image,
              let vPhotoTemp3 = self.vehicleImage3.image else {
            Helpers().showAlert(view: self, message: "Vehicle photo must be entered !".localiz())
            return}
        
        
        let userImage = Helpers().convertImageToBase64String(img: userImgTemp)
        let vCerPhoto = Helpers().convertImageToBase64String(img: vCerPhotoTemp)
        let vPhoto1 = Helpers().convertImageToBase64String(img: vPhotoTemp1)
        let vPhoto2 = Helpers().convertImageToBase64String(img: vPhotoTemp2)
        let vPhoto3 = Helpers().convertImageToBase64String(img: vPhotoTemp3)
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateAdd = formater.string(from: Date())
        
        let dataToPost: RegisterData = RegisterData(photo: userImage,
                                                    first_name: firstName,
                                                    last_name: lastName,
                                                    first_name_hiragana: firstNameHiragana,
                                                    last_name_hiragana: lastNameHiragana,
                                                    birthday_date: dateOfBirth,
                                                    postal_code: postalCode,
                                                    prefecture: prefectures,
                                                    municipal_district: municipalDis,
                                                    chome: chome,
                                                    municipality_kana: municKana,
                                                    kana_after_address: kanaAfterAddress,
                                                    sex: gender.lowercased(),
                                                    language: "jp",
                                                    phone_number: phoneNumber,
                                                    email: email,
                                                    password: password,
                                                    driver_license_number: licenseNumber,
                                                    driver_license_expired_date: licenseExpDate,
                                                    insurance_company_name: insuranceCom,
                                                    coverage_personal: personalCov,
                                                    compensation_range_objective: comRangeObj,
                                                    insurance_expiration_date: insuranceExpDate,
                                                    vehicle_name: vName,
                                                    vehicle_number_plate: vPlate,
                                                    vehicle_year: vYear,
                                                    vehicle_ownership: vOwner,
                                                    vehicle_inspection_certificate_expiration_date: vCerExp,
                                                    vehicle_inspection_certificate_photo: vCerPhoto,
                                                    vehicle_photo_1: vPhoto1,
                                                    vehicle_photo_2: vPhoto2,
                                                    vehicle_photo_3: vPhoto3,
                                                    date_add: dateAdd)
        let action1 = UIAlertAction(title: "Yes".localiz(), style: .default) {[weak self] (_) in
            self?.register(data: dataToPost)
        }
        let action2 = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message: "Continue to register ?".localiz(),
                            customTitle: "Are you sure ?".localiz(), customAction1: action2, customAction2: action1)
        //MARK: - End
    }
    
    
    func register(data: RegisterData){
        spiner.show(in: view)
        registerVm.register(data: data) { (res) in
            switch res {
            case .success(let oke):
                DispatchQueue.main.async {
                    if oke == true {
                        self.spiner.dismiss()
                        let action = UIAlertAction(title: "Oke".localiz(), style: .default) {[weak self] (_) in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        Helpers().showAlert(view: self, message: "Registration data has been sent please wait us to verification your data. We will contact you by email.".localiz(), customTitle: "Registration success".localiz(),customAction1: action)
                    }
                }
            case .failure(let error):
                self.spiner.dismiss()
                Helpers().showAlert(view: self, message: error.localizedDescription)
            }
        }
    }
}


//MARK: - Keyboard

@available(iOS 13.0, *)
extension RegisterView {
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
}


@available(iOS 13.0, *)
extension RegisterView {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        // Get required info out of the notification
        if  let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap

            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
