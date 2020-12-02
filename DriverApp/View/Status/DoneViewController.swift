//
//  DoneViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit

class DoneViewController: UIViewController {
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(named: "successIcon")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var titleLabel = Reusable.makeLabel(text: "SUCCESS", font: .systemFont(ofSize: 20, weight: .semibold), color: .black, alignment: .center)
    
    lazy var subTitleLabel = Reusable.makeLabel(text: "Your Delivery Task Done", font: .systemFont(ofSize: 16, weight: .medium), color: .black, alignment: .center)

    let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Back to Homescreen", for: .normal)
        button.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(submitButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        configureLayout()
        configureNavigationBar()
        
    }
    
    func configureLayout(){
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.height/3, width: 100, height: 100)
        imageView.centerX(toView: view)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = true
        
        titleLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
        titleLabel.centerX(toView: view)
        
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
        subTitleLabel.centerX(toView: view)
        
        submitButton.anchor(top: subTitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30)
        submitButton.centerX(toView: view)
        
        
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
