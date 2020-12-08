//
//  LoginView.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import AesEverywhere
import JGProgressHUD
import BLTNBoard

@available(iOS 13.0, *)
class LoginView: UIViewController {
    
    var loginViewModel = LoginViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    //MARK: - Blur
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.3
        return view
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var scrollView: UIScrollView = {
            let view = UIScrollView(frame: .zero)
        view.backgroundColor = .clear
            view.frame = self.view.bounds
            view.contentSize = contentViewSize
            view.autoresizingMask = .flexibleHeight
            view.showsHorizontalScrollIndicator = false
            view.showsVerticalScrollIndicator = false
            view.bounces = false
            return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "orangeKasumi")
        view.layer.cornerRadius = 10
        view.layoutIfNeeded()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let imageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "bgLogin")
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let labelTitleLogin: UILabel = {
       let label = UILabel()
        label.text = "LOGIN"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let forgetPassword: UILabel = {
       let label = UILabel()
        label.text = "Forgot your password"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let lableCode = Reusable.makeLabel(text: "Driver Code", color: .white)
    let lablePass = Reusable.makeLabel(text: "Password", color: .white)
    
    private let codeDriver: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.text = "20110066"
        field.textColor = .white
        field.keyboardType = .numberPad
        return field
    }()

    private let password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.paddingRight(10)
        field.text = "admin"
        field.textColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Submit", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        loginButton.layer.cornerRadius = 45/2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        return loginButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bgKasumi")
        view.addSubview(visualEffectView)
        view.addSubview(scrollView)
        view.insertSubview(imageView, at: 0)
        
        scrollView.addSubview(containerView)
        
        visualEffectView.fill(toView: view)
        
        codeDriver.delegate = self
        password.delegate = self
        loginViewModel.delegate = self
        
        
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
        forgetPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didForgetClick)))
        
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))

        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))

        //We make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
    }
    
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController!.navigationBar.shadowImage = UIImage()
          self.navigationController!.navigationBar.isTranslucent = true
    }
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerView.dropShadow(color: .black, opacity: 0.6, offSet: CGSize(width: 3, height: -3), radius: 10, scale: true)
        codeDriver.addBorder(toSide: .Bottom, withColor: UIColor.white.cgColor, andThickness: 1)
        password.addBorder(toSide: .Bottom, withColor: UIColor.white.cgColor, andThickness: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 200)
        
        containerView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: view.frame.width/3, paddingBottom: 20, paddingLeft: 20,  paddingRight: 20)

        
        containerView.addSubview(labelTitleLogin)
        labelTitleLogin.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 40, paddingLeft: 10, paddingRight: 10)
        
        containerView.addSubview(lableCode)
        lableCode.anchor(top: labelTitleLogin.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingRight: 10)
        containerView.addSubview(codeDriver)
        codeDriver.anchor(top: lableCode.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 45)
        
        containerView.addSubview(lablePass)
        lablePass.anchor(top: codeDriver.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingRight: 10)
        containerView.addSubview(password)
        password.anchor(top: lablePass.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 45)
        
        containerView.addSubview(forgetPassword)
        forgetPassword.anchor(top: password.bottomAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingRight: 10)
        
        containerView.addSubview(loginButton)
        loginButton.anchor(top: forgetPassword.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 30,paddingLeft: 20,paddingRight: 20, height: 45)
        
    
    }
}


//MARK- function

@available(iOS 13.0, *)
extension LoginView{
    @objc func didLoginTap(){
        codeDriver.resignFirstResponder()
        password.resignFirstResponder()
        
        guard let codeDriver = codeDriver.text, let password = password.text,
              codeDriver != "" && password != ""
              else {
            let action = UIAlertAction(title: "Oke", style: .default) { [weak self] _ in
                self?.codeDriver.becomeFirstResponder()
            }
            Helpers().showAlert(view: self, message: "Please input code driver and password !", customTitle: "Hmm", customAction1: action)
            return
        }
        spiner.show(in: view)
        loginViewModel.signIn(codeDriver: codeDriver, password: password)
    }
    
//    @objc func didForgetClick(){
//        let forgetVc = ForgetViewController()
//        navigationController?.pushViewController(forgetVc, animated: true)
//
//    }
    
    //MARK: - Show modal
    @objc
    func didForgetClick(){
        let slideVC = ForgotView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }

}


//MARK - UITextField
@available(iOS 13.0, *)
extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeDriver {
            password.becomeFirstResponder()
        }else{
            didLoginTap()
        }
        
        return true
    }
}


@available(iOS 13.0, *)
extension LoginView: LoginViewModelDelegate {
    func didLoginSuccess(_ viewModel: LoginViewModel, user: User) {
        codeDriver.text = ""
        password.text = ""
        DispatchQueue.main.async {
            
            let userData: [String:Any] = [
                "codeDriver": user.codeDriver,
                "idDriver":user.id,
                "status": "\(user.status)"
            ]
          
                UserDefaults.standard.setValue(userData, forKey: "userData")
                self.dismiss(animated: false, completion: nil)
                self.spiner.dismiss()
        }
    }
    
    func didFailedLogin(_ error: Error) {
        let action = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            self?.codeDriver.becomeFirstResponder()
        }
        Helpers().showAlert(view: self, message: "Code driver or password wrong !", customAction1: action)
        codeDriver.text = ""
        password.text = ""
        self.spiner.dismiss()
    }
}



//MARK: - Keyboard

@available(iOS 13.0, *)
extension LoginView {
    
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
extension LoginView {
    
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

@available(iOS 13.0, *)
extension LoginView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ForgotPassword(presentedViewController: presented, presenting: presenting)
    }
}
