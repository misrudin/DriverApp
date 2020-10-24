//
//  MainVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import NVActivityIndicatorView

class MainVc: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
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
        let dayOffVc = UINavigationController(rootViewController: DayOffViewController())
        dayOffVc.title = "Day Off"
        let profileVc = ProfileViewController()
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
        let vc = LoginVc()
        vc.modalPresentationStyle = .fullScreen
        if UserDefaults.standard.value(forKey: "userData") != nil {
            vc.dismiss(animated: true, completion: nil)
            configureNavigation()
        }else {
            present(vc, animated: false, completion: nil)
        }
    }
    
    
    
}
