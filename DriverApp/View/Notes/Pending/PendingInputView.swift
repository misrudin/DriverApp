//
//  PendingInputView.swift
//  DriverApp
//
//  Created by Indo Office4 on 07/01/21.
//

import UIKit
import JGProgressHUD
import AutoKeyboard
import LanguageManager_iOS

@available(iOS 13.0, *)
class PendingInputView: UIViewController {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var item1: UIView!
    @IBOutlet weak var item2: UIView!
    @IBOutlet weak var item3: UIView!
    @IBOutlet weak var item4: UIView!
    @IBOutlet weak var item5: UIView!
    
    var orderData: NewOrderData?
    
    let noteViewModel = NoteViewModel()
    var databaseM = DatabaseManager()
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    //MARK: - LIFECYCLE
    
    private var presentingController: UIViewController?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingController = presentingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "grayKasumi")
        content.backgroundColor = .white
        content.layer.cornerRadius = 5
        let items = [item1,item2,item3,item4, item5]
        _ = items.enumerated().map { (i, e) in
            e?.backgroundColor = .clear
            if i != items.count-1 {
                e?.addBorder(toSide: .Bottom, withColor: UIColor.rgba(red: 0, green: 0, blue: 0,alpha: 0.1).cgColor, andThickness: 1)
                e?.isUserInteractionEnabled = true
                let tap = CustomTap(target: self, action: #selector(tapQuickChat))
                tap.ourCustomValue = i
                e?.addGestureRecognizer(tap)
            }
        }
        
        item5.isUserInteractionEnabled = true
        item5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOther)))
        
        note.autocapitalizationType = .none
        note.autocorrectionType = .no
        note.returnKeyType = .continue
        note.layer.cornerRadius = 5
        note.layer.borderWidth = 1
        note.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        note.layer.shadowOpacity = 0.5
        note.backgroundColor = .white
        note.dataDetectorTypes = .all
        note.textAlignment = .left
        note.font = UIFont.systemFont(ofSize: 16)
        note.isEditable = true
        
        submit.backgroundColor = UIColor(named: "orangeKasumi")
        submit.setTitleColor(.white, for: .normal)
        submit.layer.cornerRadius = 5
        submit.layer.masksToBounds = true
        submit.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        submit.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        cancel.backgroundColor = UIColor.darkGray
        cancel.setTitleColor(.white, for: .normal)
        cancel.layer.cornerRadius = 5
        cancel.layer.masksToBounds = true
        cancel.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        cancel.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        
        configureNavigationBar()
    }

    func configureNavigationBar(){
        navigationItem.title = "Pending Delivery".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc private func tapOther(){
        note.becomeFirstResponder()
        note.text = ""
    }
    
    @objc func tapQuickChat(sender: CustomTap){
        let messages:[String] = [
        "Address cannot be found", "Person not at home", "Package not correct", "I have an accidents"
        ]
        
        guard let index = sender.ourCustomValue as? Int else {
            return
        }
        
        note.text = messages[index]
    }
    

}


@available(iOS 13.0, *)
extension PendingInputView {
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
              let note = note.text, note.count > 5 else {
            print("No user data")
            return
        }
        
        let metaData = MetaData(order_number: orderNo, id_shift_time: Int(idShiftTime), status_chat: false, status_done: false)
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
                    self.databaseM.removeCurrentOrder(orderNo: orderNo, codeDriver: codeDriver) { (res) in
                        print(res)
                    }
                }
            case .failure(let error):
                print(error)
                self.spiner.dismiss()
            }
        }
    }
}
