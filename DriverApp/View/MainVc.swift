//
//  MainVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import LanguageManager_iOS

@available(iOS 13.0, *)
class MainVc: UIViewController {
    
    var profileVm = ProfileViewModel()
    var ordervm = OrderViewModel()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        return view
    }()
    
    private let imageView = Reusable.makeImageView(image: UIImage(named: "logoKasumi"), contentMode: .scaleAspectFit)
    
    private let bg = Reusable.makeImageView(image: UIImage(named: "bgMain"), contentMode: .scaleToFill)
    
    private let loginButton = Reusable.makeButton(text: "login".localiz(),font: .systemFont(ofSize: 20, weight: .regular), color: .white, background: UIColor(named: "orangeKasumi")!, rounded: 5)
    
    private let signupButton = Reusable.makeButton(text: "register".localiz(),font: .systemFont(ofSize: 20, weight: .regular), color: UIColor(named: "orangeKasumi")!, background: .white, rounded: 5)
    
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
        signupButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, paddingLeft: 16, paddingRight: 16, height: 45)
        
        loginButton.anchor(left: view.leftAnchor, bottom: signupButton.topAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginButton.alpha = 0
        signupButton.alpha = 0
        loginButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        signupButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    

    
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
        homeVc.title = "b-job".localiz()
        let historyVc = UINavigationController(rootViewController: HistoryViewController())
        historyVc.title = "b-history".localiz()
        let dayOffVc = UINavigationController(rootViewController: DayOffVc())
        dayOffVc.title = "b-day-off".localiz()
        
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
                        else if data.currentOrder != nil && data.currentOrder != "" {
                            self!.ordervm.getDetailOrder(orderNo: data.currentOrder!) { (res) in
                                switch res {
                                case .success(let data):
                                    DispatchQueue.main.async {
                                        let vc = LiveTrackingVC()
                                        vc.order = data
                                        let navVc = UINavigationController(rootViewController: vc)
                                        navVc.modalPresentationStyle = .fullScreen
                                        self?.present(navVc, animated: true, completion: nil)
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        print(error)
                                    }
                                }
                            }
                            
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
                self.loginButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    
    
}
