//
//  PendingNoteVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit
import JGProgressHUD
import AutoKeyboard

@available(iOS 13.0, *)
class PendingNoteVc: UIViewController {
    
    var orderData: NewOrderData?
    
    let noteViewModel = NoteViewModel()
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "pendingImage")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let messagelabel = Reusable.makeLabel(text: "Tell Your Pending Delivery Reason", font: UIFont.systemFont(ofSize: 16), color: .black, alignment: .center)
    private let pendingLable = Reusable.makeLabel(text: "PENDING", font: UIFont.systemFont(ofSize: 20, weight: .semibold), color: UIColor.black, alignment: .center)
    
    private let noteInput: UITextView = {
        let field = UITextView()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
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
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - Scroll View
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        scroll.frame = self.view.bounds
        return scroll
    }()
    
    lazy var stakView: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubview(scrollView)
        scrollView.addSubview(stakView)
        stakView.addSubviews(views: imageView,pendingLable,messagelabel,submitButton,cancelButton,noteInput)
        
        noteInput.becomeFirstResponder()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerAutoKeyboard() { (result) in


        switch result.status {
        case .willShow:
        print("1")
        case .didShow:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
                self.stakView.heightAnchor.constraint(equalToConstant: 55*13).isActive = true
            })
        case .willHide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.stakView.heightAnchor.constraint(equalToConstant: 55*13).isActive = true
            })
        case .didHide:
            print("3")
        case .willChangeFrame:
            print("change")
        case .didChangeFrame:
            print("change2")
        }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterAutoKeyboard()
    }
    
    
    private var presentingController: UIViewController?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingController = presentingViewController
    }
    
    @objc func tapScV(){
        view.endEditing(true)
    }
    
    func configureLayout(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.fill(toView: view)
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapScV)))
        
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor,paddingTop: 16,paddingBottom: 16, paddingLeft: 16, paddingRight: 16,  height:(55*13))
        
        imageView.anchor(top: stakView.topAnchor, paddingTop: 20, width: view.frame.width/3, height: view.frame.width/3)
        imageView.centerXAnchor.constraint(equalTo: stakView.centerXAnchor).isActive = true
        
        pendingLable.anchor(top: imageView.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 20)
        
        messagelabel.numberOfLines = 0
        messagelabel.anchor(top: pendingLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        
        submitButton.anchor(top: noteInput.bottomAnchor, left: stakView.leftAnchor, right: cancelButton.leftAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 10, height: 40)
        
        cancelButton.anchor(top: noteInput.bottomAnchor, right: stakView.rightAnchor, paddingTop: 20, paddingRight: 16, width: 100, height: 40)
        
        noteInput.anchor(top: messagelabel.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 200)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Pending Delivery"
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
