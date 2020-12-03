//
//  MainVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

@available(iOS 13.0, *)
class MainVc: UIViewController {
    
    var profileVm = ProfileViewModel()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        return view
    }()
    
    private let imageView = Reusable.makeImageView(image: UIImage(named: "logoKasumi"), contentMode: .scaleAspectFit)
    
    private let bg = Reusable.makeImageView(image: UIImage(named: "bgMain"), contentMode: .scaleToFill)
    
    private let loginButton = Reusable.makeButton(text: "Have Account? Login",font: .systemFont(ofSize: 20, weight: .regular), color: .white, background: UIColor(named: "orangeKasumi")!, rounded: 5)
    
    private let signupButton = Reusable.makeButton(text: "Join Us - Register",font: .systemFont(ofSize: 20, weight: .regular), color: UIColor(named: "orangeKasumi")!, background: .white, rounded: 5)
    
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
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        visualEffectView.fill(toView: view)
        bg.fill(toView: view)
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.anchor(width: 64, height: 64)
        signupButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        
        loginButton.anchor(left: view.leftAnchor, bottom: signupButton.topAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        cekUser()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cekUser()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureNavigation(){
        let tabBarVc = UITabBarController()
        let homeVc = UINavigationController(rootViewController: HomeVc())
        homeVc.title = "Jobs"
        let historyVc = UINavigationController(rootViewController: HistoryViewController())
        historyVc.title = "History"
        let dayOffVc = UINavigationController(rootViewController: DayOffVc())
        dayOffVc.title = "Day Off"
        
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
                    DispatchQueue.main.async {
                        if data.restTime != nil && data.workTime == nil {
                            let vc = RestView()
                            vc.modalPresentationStyle = .fullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            self?.present(vc, animated: true, completion: nil)
                        }else {
                            self?.configureNavigation()
                        }
                    }
                case .failure(let err):
                    print("error \(err)")
                    self?.configureNavigation()
                }
            }
        }else {
            loginButton.isHidden = false
            signupButton.isHidden = false
        }
    }
    
    
    
}
