//
//  MainVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import LanguageManager_iOS
import JGProgressHUD

@available(iOS 13.0, *)
class MainVc: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var profileVm = ProfileViewModel()
    var ordervm = OrderViewModel()
    
    var shiftTimeVm = ShiftTimeViewModel()
    var activeShift: ShiftTime!
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        return view
    }()
    
    private let imageView = Reusable.makeImageView(image: UIImage(named: "logoKasumi"), contentMode: .scaleAspectFill)
    
    private let labelAppName = Reusable.makeLabel(font: .systemFont(ofSize: 15, weight: .bold), color: .white, numberOfLines: 0, alignment: .center)
    
    private let bg = Reusable.makeImageView(image: UIImage(named: "bgMain"), contentMode: .scaleToFill)
    
    private let loginButton = Reusable.makeButton(text: "Have Account? Login".localiz(),font: .systemFont(ofSize: 20, weight: .regular), color: .white, background: UIColor(named: "orangeKasumi")!, rounded: 5)
    
    private let signupButton = Reusable.makeButton(text: "Join Us - Register".localiz(),font: .systemFont(ofSize: 20, weight: .regular), color: UIColor(named: "orangeKasumi")!, background: .white, rounded: 5)
    
    private let javButton = Reusable.makeButton(text: "JP".localiz(),font: .systemFont(ofSize: 14, weight: .medium), color: UIColor(named: "orangeKasumi")!, background: .white, rounded: 5)
    
    private let engButton = Reusable.makeButton(text: "EN".localiz(),font: .systemFont(ofSize: 14, weight: .medium), color: UIColor(named: "orangeKasumi")!, background: .white, rounded: 5)
    
    @objc
    func login(){
        let loginvc = UINavigationController(rootViewController: LoginView())
//        let loginvc = LoginView()
        loginvc.modalPresentationStyle = .fullScreen
        present(loginvc, animated: true, completion: nil)
    }
    
    @objc
    func register(){
        let vc = UINavigationController(rootViewController: RegisterView())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(visualEffectView)
        view.insertSubview(bg, at: 0)
        view.addSubview(imageView)
        view.addSubview(labelAppName)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
    
        
        loginButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        signupButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        if let displayName = Bundle.main.displayName {
            labelAppName.text = displayName
        }
        
        view.addSubview(javButton)
        view.addSubview(engButton)
        
        javButton.isHidden = false
        engButton.isHidden = false
        visualEffectView.fill(toView: view)
        bg.fill(toView: view)
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.anchor(width: 100, height: 100)
        labelAppName.translatesAutoresizingMaskIntoConstraints = false
        labelAppName.bottom(toAnchor: imageView.bottomAnchor, space: 30)
        labelAppName.left(toAnchor: view.leftAnchor, space: 10)
        labelAppName.right(toAnchor: view.rightAnchor, space: -10)
        labelAppName.isHidden = true
        
        signupButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, paddingLeft: 16, paddingRight: 16, height: 45)
        
        loginButton.anchor(left: view.leftAnchor, bottom: signupButton.topAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
       
        javButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: engButton.leftAnchor, paddingTop: 16, paddingRight: 10, width: 60, height: 30)
        
        engButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16, width: 60, height: 30)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    
        javButton.addTarget(self, action: #selector(didTapJav), for: .touchUpInside)
        engButton.addTarget(self, action: #selector(didTapEng), for: .touchUpInside)
        
        cekLanguageActive()
        
    }
    
    @objc private func didTapJav(){
        UserDefaults.standard.setValue("JP", forKey: "language")
        javButton.setTitleColor(.white, for: .normal)
        javButton.backgroundColor = UIColor(named: "orangeKasumi")
        engButton.setTitleColor(UIColor(named: "orangeKasumi")!, for: .normal)
        engButton.backgroundColor = .white
        LanguageManager.shared.setLanguage(language: .ja)
           { title -> UIViewController in
             let storyboard = MainVc()
            return storyboard
           } animation: { view in
             view.transform = CGAffineTransform(scaleX: 0, y: 0)
             view.alpha = 0
           }
    }
    
    @objc private func didTapEng(){
        UserDefaults.standard.setValue("EN", forKey: "language")
        javButton.setTitleColor(UIColor(named: "orangeKasumi")!, for: .normal)
        javButton.backgroundColor = .white
        engButton.setTitleColor(.white, for: .normal)
        engButton.backgroundColor = UIColor(named: "orangeKasumi")
        LanguageManager.shared.setLanguage(language: .en)
           { title -> UIViewController in
             let storyboard = MainVc()
            return storyboard
           } animation: { view in
             view.transform = CGAffineTransform(scaleX: 0, y: 0)
             view.alpha = 0
           }
    }
    
    private func cekLanguageActive(){
        guard let language = UserDefaults.standard.value(forKey: "language") as? String else {
            javButton.setTitleColor(.white, for: .normal)
            javButton.backgroundColor = UIColor(named: "orangeKasumi")
            engButton.setTitleColor(UIColor(named: "orangeKasumi")!, for: .normal)
            engButton.backgroundColor = .white
            return
        }
        
        if(language == "EN"){
            javButton.setTitleColor(UIColor(named: "orangeKasumi")!, for: .normal)
            javButton.backgroundColor = .white
            engButton.setTitleColor(.white, for: .normal)
            engButton.backgroundColor = UIColor(named: "orangeKasumi")
        }else {
            javButton.setTitleColor(.white, for: .normal)
            javButton.backgroundColor = UIColor(named: "orangeKasumi")
            engButton.setTitleColor(UIColor(named: "orangeKasumi")!, for: .normal)
            engButton.backgroundColor = .white
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.alpha = 0
        signupButton.alpha = 0
        engButton.alpha = 0
        javButton.alpha = 0
        cekUser()
        cekLanguageActive()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureNavigation(){
        let tabBarVc = UITabBarController()
        let homeVc = UINavigationController(rootViewController: HomeVc())
        homeVc.title = "Jobs".localiz()
        let historyVc = UINavigationController(rootViewController: HistoryViewController())
        historyVc.title = "History".localiz()
        let dayOffVc = UINavigationController(rootViewController: EditCurrentDayOff())
        dayOffVc.title = "Day Off".localiz()
        
        let image1 = UIImage(named: "jobHistory")
        let baru1 = image1?.resizeImage(CGSize(width: 25, height: 25))
        let image2 = UIImage(named: "jobList")
        let baru2 = image2?.resizeImage(CGSize(width: 25, height: 25))
        let image3 = UIImage(named: "dayOff")
        let baru3 = image3?.resizeImage(CGSize(width: 25, height: 25))
        
        let images = [baru1,baru2,baru3]
        
        tabBarVc.setViewControllers([historyVc,homeVc, dayOffVc], animated: true)
        
        guard let items = tabBarVc.tabBar.items else {
            return
        }
        
        for x in 0..<items.count {
                items[x].image = images[x]
        }
        
        tabBarVc.modalPresentationStyle = .fullScreen
        tabBarVc.modalTransitionStyle = .crossDissolve
        tabBarVc.selectedIndex = 1
        present(tabBarVc, animated: true, completion: nil)
    }
    
    
    func cekUser() {
        
        if UserDefaults.standard.value(forKey: "userData") != nil {
            loginButton.isHidden = true
            signupButton.isHidden = true
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any], let codeDriver = userData["codeDriver"] as? String else {
                print("No user data")
                return
            }
            profileVm.cekStatusDriver(codeDriver: codeDriver) {[weak self] (res) in
                switch res {
                case .success(let data):
                    print(data)
                    DispatchQueue.main.async {
                        if data.restTime != nil && data.workTime == nil {
                            let vc = RestView()
                            vc.modalPresentationStyle = .fullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            self?.present(vc, animated: true, completion: nil)
                        }
                        else {
                            self?.configureNavigation()
                        }
                    }
                case .failure(let err):
                    print("error \(err)")
                    self?.configureNavigation()
                }
            }
        }else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.loginButton.isHidden = false
                self.signupButton.isHidden = false
                self.loginButton.alpha = 1
                self.signupButton.alpha = 1
                self.engButton.alpha = 1
                self.javButton.alpha = 1
                self.loginButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    
    
}


extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
