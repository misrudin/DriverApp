
import UIKit
import JGProgressHUD

class EditEmail: UIViewController {
    
    var profileVm = ProfileViewModel()
    
    var codeDriver: String = ""
    var driverEmail: String = ""
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
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
        return field
    }()
    
    private let submitButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Save", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(emailLable)
        view.addSubview(email)
        view.addSubview(submitButton)
        
        email.text = driverEmail
        
        configureLayout()
        configureNavigationBar()
        
        submitButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Edit Email"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didSubmit(){
        guard let email = self.email.text, email != "" else {
            Helpers().showAlert(view: self, message: "Please enter an email !")
            return}
  
        if Validation().isValidEmail(email) == false {
            Helpers().showAlert(view: self, message: "Please use a valid email !")
            return
        }
        
        let data: UpdateEmail = UpdateEmail(email: email, code_driver: codeDriver)
        
        profileVm.updateEmail(data: data) { (res) in
            switch res {
            case .success(let oke):
                if oke == true {
                    Helpers().showAlert(view: self, message: "Success update email")
                }
            case .failure(let err):
                Helpers().showAlert(view: self, message: err.localizedDescription)
            }
        }
            
        
    }
    
    
    
    func configureLayout(){
        emailLable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        email.anchor(top: emailLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, height: 45)
        submitButton.anchor(top: email.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 45)
    }
}
