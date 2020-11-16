//
//  MainVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

class MainVc: UIViewController {
    
    var profileVm = ProfileViewModel()
    
    private let imageView: UIImageView = {
       let img = UIImageView()
        img.layer.cornerRadius = 5
        img.image = UIImage(named: "logoKasumi")
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let loginButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold )
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.isHidden = true
        return loginButton
    }()
    
    private let signupButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Sign Up", for: .normal)
        loginButton.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        loginButton.setTitleColor(UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2), for: .highlighted)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold )
        loginButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginButton.isHidden = true
        return loginButton
    }()
    
    @objc
    func login(){
        let loginvc = UINavigationController(rootViewController: LoginView())
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
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.anchor(width: view.frame.width / 4, height: view.frame.width / 4)
        signupButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        
        loginButton.anchor(left: view.leftAnchor, bottom: signupButton.topAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        let notesVc = UINavigationController(rootViewController: NotesVc())
        notesVc.title = "Notes"
        let dayOffVc = UINavigationController(rootViewController: DayOffVc())
        dayOffVc.title = "Day Off"
        let profileVc = UINavigationController(rootViewController: ProfileViewController())
        profileVc.title = "My Account"
        
        let images = ["house.fill","clock.fill","square.and.pencil","pause.rectangle.fill","person.circle.fill"]
        
        tabBarVc.setViewControllers([homeVc,historyVc,notesVc,dayOffVc,profileVc], animated: true)
        
        guard let items = tabBarVc.tabBar.items else {
            return
        }
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVc.modalPresentationStyle = .fullScreen
        tabBarVc.modalTransitionStyle = .crossDissolve
        present(tabBarVc, animated: true, completion: nil)
    }
    
    
    func cekUser() {
//        let vc = LoginView()
//        vc.modalPresentationStyle = .fullScreen
        
        if UserDefaults.standard.value(forKey: "userData") != nil {
//            vc.dismiss(animated: false, completion: nil)
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
//            present(vc, animated: false, completion: nil)
            loginButton.isHidden = false
            signupButton.isHidden = false
        }
    }
    
    
    
}
