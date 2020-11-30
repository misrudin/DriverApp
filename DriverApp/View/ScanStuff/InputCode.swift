//
//  InputCode.swift
//  DriverApp
//
//  Created by Indo Office4 on 26/11/20.
//

import UIKit

class InputCode: UIViewController {
    
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    
    lazy var titleLable = Reusable.makeLabel(text: "Add Order Code", font: UIFont.systemFont(ofSize: 16, weight: .semibold), color: UIColor(named: "orangeKasumi")!)
    
    lazy var inputCode: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.borderColor = UIColor(named: "grayKasumi")?.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.placeholder = "Input code here ..."
        field.textAlignment  = .center
        field.paddingLeft(10)
        field.paddingRight(10)
        return field
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Verify Package", for: .normal)
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
        view.backgroundColor = .white
        title = "Add code manual"

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
        navigationController?.title = "Add code manual"
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
        
        print(code)
        let codes: [String] = [code]
        let data: Scan = Scan(order_number: orderNo, qr_code_raw: codes)
        orderVm.changeStatusItems(data: data) {[weak self] (res) in
            switch res {
            case .success(let oke):
                DispatchQueue.main.async {
                    if oke == true {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let err):
                let action1 = UIAlertAction(title: "Try Again", style: .default) {[weak self] (_) in
                    self?.inputCode.becomeFirstResponder()
                }
                Helpers().showAlert(view: self!, message: "Something when wrong !, Item code not found.", customAction1: action1)
                print(err)
            }
        }
        
    }

}
