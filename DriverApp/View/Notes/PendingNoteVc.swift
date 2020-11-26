//
//  PendingNoteVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit
import JGProgressHUD

@available(iOS 13.0, *)
class PendingNoteVc: UIViewController {
    
    var orderData: NewOrderData?
    
    let noteViewModel = NoteViewModel()
    
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
    
    
    private var presentingController: UIViewController?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingController = presentingViewController
    }
    
    func configureLayout(){
        submitButton.anchor(top: noteInput.bottomAnchor, left: view.leftAnchor, right: cancelButton.leftAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 10, height: 40)
        
        cancelButton.anchor(top: noteInput.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 16, width: 100, height: 40)
        
        noteInput.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 200)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Give a pending reason"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    }
    
}


@available(iOS 13.0, *)
extension PendingNoteVc {
    @objc
    func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapSubmit(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let orderNo = orderData?.order_number,
              let idShiftTime = orderData?.id_shift_time,
              let note = noteInput.text, note.count > 5 else {
            print("No user data")
            return
        }
        
        let metaData = MetaData(order_number: orderNo, id_shift_time: String(idShiftTime))
        let data = DataPending(code_driver: codeDriver, note: note, meta_data: metaData)
        spiner.show(in: view)
        noteViewModel.pendingNote(data: data) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    self.dismiss(animated: true) {
                        self.presentingController?.dismiss(animated: false)
                    }
                }
            case .failure(let error):
                print(error)
                self.spiner.dismiss()
            }
        }
    }
}
