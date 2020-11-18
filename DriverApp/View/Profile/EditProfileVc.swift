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
    var profileVm = ProfileViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    var newFoto:String?
    
    
    let imageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "personCircle")
        
        return image
    }()
    
    let buttonCamera: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "cameraIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        button.setImage(baru, for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    
    private let firstName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
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
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
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
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
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
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "Confirm New Password ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.keyboardType = .emailAddress
        return field
    }()
    
    private let mobileNumber1: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "0000"
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    private let mobileNumber2: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "0000"
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    private let mobileNumber3: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        field.placeholder = "0000"
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    
    let mnContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        return stack
    }()


    
    private let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        return button
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
        view.addSubview(lableCoutryCode)
        view.addSubview(mnContainer)
        mnContainer.addArrangedSubview(mobileNumber1)
        mnContainer.addArrangedSubview(mobileNumber2)
        mnContainer.addArrangedSubview(mobileNumber3)
        view.addSubview(submitButton)
        view.addSubview(imageView)
        view.addSubview(buttonCamera)
        buttonCamera.bringSubviewToFront(imageView)
        
        configureLayout()
        
        firstName.text = dataDriver?.firstName
        lastName.text = dataDriver?.lastName
        email.text = dataDriver?.email
        mobileNumber1.text = "\(dataDriver?.mobileNumber1 ?? "")"
        mobileNumber2.text = "\(dataDriver?.mobileNumber2 ?? "")"

        mobileNumber3.text = "\(dataDriver?.mobileNumber3 ?? "")"

        
        guard let photoUrl = dataDriver?.photoUrl, let photoName = dataDriver?.photoName else {return}
        if let urlString = URL(string: "\(photoUrl)\(photoName)") {
            let placeholderImage = UIImage(named: "personCircle")
            self.imageView.af.setImage(withURL: urlString, placeholderImage: placeholderImage)
        }
    }
    
    @objc
    func updateProfile(){
        guard let iddriver = dataDriver?.idDriver,
              let first = firstName.text,
              let last = lastName.text,
            let mobile1 = mobileNumber1.text,
            let mobie2 = mobileNumber2.text,
            let mobile3 = mobileNumber3.text,
            let emailText = email.text else {
            return
        }
        
        spiner.show(in: view)
        
        let data: DataProfile = DataProfile(id_driver: iddriver, first_name: first, last_name: last, mobile_number1: mobile1, mobile_number2: mobie2, mobile_number3: mobile3, country_code: "+81", email: emailText)
        
        if let foto = newFoto {
            print("edit foto")
            profileVm.updateFoto(data: foto, codeDriver: dataDriver!.codeDriver) { (res) in
                switch res {
                case .success(let result):
                    print(result)
                case .failure(let err):
                    print(err)
                }
            }
        }
        
        
        
        profileVm.updateProfile(data: data) {[weak self] (result) in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self?.spiner.dismiss()
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    self?.spiner.dismiss()
                }
            }
        }
        
    }
    
    func configureLayout(){
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 250)
        firstName.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 10, paddingRight: 10,height: 50)
        lastName.anchor(top: firstName.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10,height: 50)
        email.anchor(top: lastName.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10,height: 50)
        lableCoutryCode.anchor(top: email.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10,width: 30,height: 50)
        mnContainer.anchor(top: email.bottomAnchor, left: lableCoutryCode.rightAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)

        submitButton.anchor(top: mobileNumber1.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 50)
        
        buttonCamera.anchor(top: imageView.bottomAnchor, right: imageView.rightAnchor, paddingTop: -25, paddingRight: 16, width: 40, height: 40)
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
    
    @objc func didBack(){
        dismiss(animated: true)
    }
    
    @objc
    func addPhoto(){
        presentPhotoActionSheet()
    }
    
    
}


@available(iOS 13.0, *)
extension EditProfileVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
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
           picker.dismiss(animated: true, completion: nil)
           guard let selectdedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
               return
           }
           
           newFoto = convertImageToBase64String(img: selectdedImage)
        
           self.imageView.image = selectdedImage
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return "data:image/png;base64,\(img.jpegData(compressionQuality: 0.7)?.base64EncodedString() ?? "")"
    }
}
