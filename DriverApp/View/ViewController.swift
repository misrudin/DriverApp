//
//  ViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        autentikasiUser()
    }
    
    func autentikasiUser(){
        let vc = LoginVc()
        if let user = UserDefaults.standard.value(forKey: "userData") {
            print("Curren user \(user)")
        }else {
            print("No current user please login first")
            present(vc, animated: true)
        }
    }


}

