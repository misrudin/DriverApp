//
//  EditProfileVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 23/10/20.
//

import UIKit
import AlamofireImage

class EditProfileVc: UIViewController {
    
    var dataDriver: UserModel? = nil
    var profileVm = ProfileViewModel()
    let pop = PopUpView()
    
    
    let imageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person")
        image.tintColor = .systemGray5
        
        return image
    }()
    
    
    private let firstName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    
    private let lastName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let newPassword: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "New Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let email: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Confirm New Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.keyboardType = .emailAddress
        return field
    }()
    
    private let mobileNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "0000 0000 0000"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.keyboardType = .emailAddress
        return field
    }()
    
    private let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        return button
    }()
    
    private let lableError: UILabel = {
       let label = UILabel()
        label.text = "...."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .red
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 5
        label.isHidden = true
        return label
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
        
        view.addSubview(firstName)
        view.addSubview(lastName)
        view.addSubview(email)
        view.addSubview(lableError)
        view.addSubview(lableCoutryCode)
        view.addSubview(mobileNumber)
        view.addSubview(submitButton)
        view.addSubview(imageView)
        
        configureLayout()
        
        firstName.text = dataDriver?.firstName
        lastName.text = dataDriver?.lastName
        email.text = dataDriver?.email
        mobileNumber.text = "\(dataDriver?.mobileNumber1 ?? "") \(dataDriver?.mobileNumber2 ?? "") \(dataDriver?.mobileNumber3 ?? "")"
        
        guard let photoUrl = dataDriver?.photoUrl, let photoName = dataDriver?.photoName else {return}
        if let urlString = URL(string: "\(photoUrl)\(photoName)") {
            let placeholderImage = UIImage(systemName: "person")
            self.imageView.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
        }
    }
    
    @objc
    func updateProfile(){
        guard let iddriver = dataDriver?.idDriver,
              let first = firstName.text,
              let last = lastName.text,
            let mobile1 = mobileNumber.text,
            let mobie2 = mobileNumber.text,
            let mobile3 = mobileNumber.text,
            let emailText = email.text else {
            return
        }
        
        view.addSubview(pop)
        pop.show = true
        
        let data: DataProfile = DataProfile(id_driver: iddriver, first_name: first, last_name: last, mobile_number1: mobile1, mobile_number2: mobie2, mobile_number3: mobile3, country_code: "+81", email: emailText)
        
        profileVm.updateProfile(data: data) {[weak self] (result) in
            switch result{
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self?.pop.show = false
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    self?.pop.show = false
                }
            }
        }
        
    }
    
    func configureLayout(){
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 250)
        firstName.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10,height: 50)
        lastName.anchor(top: firstName.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10,height: 50)
        email.anchor(top: lastName.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10,height: 50)
        lableCoutryCode.anchor(top: email.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10,width: 30,height: 50)
        mobileNumber.anchor(top: email.bottomAnchor, left: lableCoutryCode.rightAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        lableError.anchor(top: mobileNumber.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        submitButton.anchor(top: lableError.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 50)
    }
    

    func configureNavigationBar(){
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didBack))
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didBack(){
        dismiss(animated: true)
    }
    
    
}
