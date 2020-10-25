//
//  DoneViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit

class DoneViewController: UIViewController {

    let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(submitButton)
        configureLayout()
        configureNavigationBar()
    }
    
    func configureLayout(){
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    private var presentingController: UIViewController?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingController = presentingViewController
    }
    
    @objc
    func didTapBack(){
        self.dismiss(animated: true) {
            self.presentingController?.dismiss(animated: false)
        }
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Done Delivery"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    }

}
