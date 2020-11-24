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
        let format = DateFormatter()
        if let date =  bio?.driver_license_expiration_date {
            guard let dateFrom = format.date(from: date) else {
                return
            }
            datePickerExpiration.date = dateFrom
        }
        

        
        guard let photoUrl = bio?.photo_url, let photoName = bio?.photo_name else {return}
        if let urlString = URL(string: "\(photoUrl)\(photoName)") {
            let placeholderImage = UIImage(named: "personCircle")
            self.profilePhotoImage.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
        }
        
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))

        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))

        //We make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
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
    
    func configureLayout(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor,paddingTop: 16,paddingBottom: 16, paddingLeft: 16, paddingRight: 16,  height:(55*13))
        
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


@available(iOS 13.0, *)
extension EditProfileVc {
    
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
extension EditProfileVc {
    
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
