//
//  EditNoteView.swift
//  DriverApp
//
//  Created by Indo Office4 on 10/11/20.
//

import UIKit

class EditNoteView: UIViewController {
    
    var note: String?
    var id: Int?
    var type: String?
    
    let pop = PopUpView()
    
    var noteViewModel = NoteViewModel()
    
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
    
    @objc
    func didTapSubmit(){
        guard let type = type else {
            return
        }
        
        if type == "CHECKOUT" {
            editNoteCheckout()
        }else{
            editNotePending()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noteInput)
        view.addSubview(submitButton)
        
        if let note = note {
            noteInput.text = note
        }
        
        

        view.backgroundColor = .white
        configureNavigationBar()
        configureLayout()
    }
    
    private func editNotePending(){
        guard let id = id, let note = noteInput.text, note.count > 3 else {
            return
        }
        
        view.addSubview(pop)
        self.pop.show = true
        
        noteViewModel.editNotePending(id: id, note: note) { (res) in
            switch res {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.pop.show = false
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func editNoteCheckout(){
        guard let id = id, let note = noteInput.text, note.count > 3 else {
            return
        }
        
        view.addSubview(pop)
        self.pop.show = true
        
        noteViewModel.editNoteCheckout(id: id, note: note) { (res) in
            switch res {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.pop.show = false
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func configureLayout(){
        noteInput.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 200)
        
        submitButton.anchor(top: noteInput.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 45)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Edit Notes"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }

}
