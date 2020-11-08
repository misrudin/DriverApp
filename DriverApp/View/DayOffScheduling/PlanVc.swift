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
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Set Plan Next Month"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipses.bubble.fill"), style: .plain, target: self, action: #selector(onClickChatButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didBack))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
    }

}
