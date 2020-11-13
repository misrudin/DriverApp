//
//  MainVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

class MainVc: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.anchor(width: view.frame.width / 4, height: view.frame.width / 4)
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
        
        present(tabBarVc, animated: true, completion: nil)
    }
    
    
    func cekUser() {
        let vc = LoginView()
        vc.modalPresentationStyle = .fullScreen
        if UserDefaults.standard.value(forKey: "userData") != nil {
            vc.dismiss(animated: false, completion: nil)
            configureNavigation()
        }else {
            present(vc, animated: false, completion: nil)
        }
    }
    
    
    
}
