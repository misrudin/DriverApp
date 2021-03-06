//
//  PendingNoteVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit

class PendingNoteVc: UIViewController {
    
    var orderData: Order?
    
    let noteViewModel = NoteViewModel()
    
    let pop = PopUpView()
    
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


extension PendingNoteVc {
    @objc
    func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapSubmit(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let idDriver = userData["idDriver"] as? Int,
              let idOrder = orderData?.idOrder,
              let note = noteInput.text,
              let idShift = orderData?.idShiftTime, note.count > 5 else {
            print("No user data")
            return
        }
        
        let data = DataPending(id_driver: idDriver, note: note, id_order: idOrder, id_shift_time: idShift)
        view.addSubview(pop)
        self.pop.show = true
        noteViewModel.pendingNote(data: data) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.pop.show = false
                    self.dismiss(animated: true) {
                        self.presentingController?.dismiss(animated: false)
                    }
                }
            case .failure(let error):
                print(error)
                self.pop.show = false
            }
        }
    }
}
