//
//  RegisterView.swift
//  DriverApp
//
//  Created by Indo Office4 on 10/11/20.
//

import UIKit

class RegisterView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Sign Up"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
}
