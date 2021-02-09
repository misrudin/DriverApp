//
//  InputCode.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit

@available(iOS 13.0, *)
class InputCode: UIViewController {
    
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    var list: [PickupItem]!
    var codeQr: String = ""
    var extra: Bool = false
    weak var delegate: ListScanView!
    
    lazy var titleLable = Reusable.makeLabel(text: "Add Order Code".localiz(), font: UIFont.systemFont(ofSize: 16, weight: .semibold), color: UIColor(named: "orangeKasumi")!)
    
    lazy var inputCode: UITextField = {
        let field = UITextField()
        field.backgroundColor = .clear
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.placeholder = "Input code here ...".localiz()
        field.textAlignment  = .center
        field.paddingLeft(10)
        field.paddingRight(10)
        return field
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Verify Package".localiz(), for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(submitCode), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        title = "Add code manual".localiz()

        configureUi()
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        inputCode.addBorder(toSide: .Bottom, withColor: UIColor.black.cgColor, andThickness: 1)
        inputCode.becomeFirstResponder()
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.title = "Add code manual".localiz()
    }
    
    private func configureUi(){
        view.addSubview(titleLable)
        titleLable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(inputCode)
        inputCode.anchor(top: titleLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        
        view.addSubview(submitButton)
        submitButton.anchor(top: inputCode.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 45)
    }
    
    @objc
    private func submitCode(){
        guard let code = inputCode.text else {
            return
        }
        
//        let find = list.filter({ $0.qr_code_raw == code })
        if code != codeQr {
            let action1 = UIAlertAction(title: "Try Again".localiz(), style: .default, handler: nil)
            Helpers().showAlert(view: self, message: "Item code not found.".localiz(), customAction1: action1)
        }else {
            delegate.updateList(code: code)
            navigationController?.popViewController(animated: true)
        }
        
    }

}
