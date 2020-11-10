//
//  PlanVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 08/11/20.
//

import UIKit

class PlanVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgKasumi")
        configureNavigationBar()
        navigationController?.isToolbarHidden = true
    }
    
    
    func configureNavigationBar(){
        navigationItem.title = "Set Plan Next Month"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    

}
