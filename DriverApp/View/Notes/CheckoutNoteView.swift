//
//  CheckoutNoteView.swift
//  DriverApp
//
//  Created by Indo Office4 on 15/11/20.
//

import UIKit
import JGProgressHUD

@available(iOS 13.0, *)
class CheckoutNoteView: UIViewController {
    
    var orderData: Order?
    
    var noteViewModel = NoteViewModel()
    var inoutVm = InOutViewModel()
    
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    private let noteInput: UITextView = {
        let field = UITextView()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray5.cgColor
        field.layer.shadowOpacity = 0.5
        field.backgroundColor = .white
        field.dataDetectorTypes = .all
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 16)
        return field
    }()
    
    let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton={
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        view.addSubview(noteInput)
        noteInput.becomeFirstResponder()
        configureLayout()
    }
    
    func configureLayout(){
        submitButton.anchor(top: noteInput.bottomAnchor, left: view.leftAnchor, right: cancelButton.leftAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 10, height: 40)
        
        cancelButton.anchor(top: noteInput.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 16, width: 100, height: 40)
        
        noteInput.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 200)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Checkout"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    }
    
}


@available(iOS 13.0, *)
extension CheckoutNoteView {
    @objc
    func didTapCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didTapSubmit(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let note = noteInput.text, note.count > 5 else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        let driver: CheckDriver = CheckDriver(code_driver: codeDriver)
        let data: DataCheckout = DataCheckout(code_driver: codeDriver, note: note)
        inoutVm.checkoutDriver(data: driver) {[weak self] (result) in
            switch result {
            case .success(let oke):
                DispatchQueue.main.async {
                    if oke == true {
                        self?.sendCheckoutNote(data: data)
                    }
                }
            case .failure(let err):
                print(err)
                self?.spiner.dismiss()
                Helpers().showAlert(view: self!, message: "Something when wrong !")
            }
        }
    }
    
    private func sendCheckoutNote(data: DataCheckout){
        noteViewModel.checkoutNote(data: data){[weak self] (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.spiner.dismiss()
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error)
                self?.spiner.dismiss()
                Helpers().showAlert(view: self!, message: "Something when wrong !")
            }
        }
    }
}
