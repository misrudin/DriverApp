//
//  PendingNoteVc.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 26/10/20.
//

import UIKit
import JGProgressHUD
import AutoKeyboard
import LanguageManager_iOS

@available(iOS 13.0, *)
class PendingNoteVc: UIViewController {
    
    //MARK: - Data
    
    var orderData: NewOrderData?
    
    let noteViewModel = NoteViewModel()
    var databaseM = DatabaseManager()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    var constraint1: NSLayoutConstraint!
    var constraint2: NSLayoutConstraint!
    
    var c1: NSLayoutConstraint!
    var c2: NSLayoutConstraint!
    var c3: NSLayoutConstraint!
    var c4: NSLayoutConstraint!
    var c5: NSLayoutConstraint!
    
    let messages:[String] = [
        "Address cannot be found".localiz(), "Person not at home".localiz(), "Package not correct".localiz(), "I have an accidents".localiz()
    ]
    
    
    //MARK: - Components
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
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
    
    private let stackView: UIView = {
       let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let titleLebel = Reusable.makeLabel(text: "Tell Your Pending Delivery Reason".localiz(),
                                        font: .systemFont(ofSize: 14, weight: .semibold),
                                        color: UIColor(named: "darkKasumi")!,
                                        numberOfLines: 0,
                                        alignment: .center)
    private let container: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    func createItemView(title: String)-> UIView{
        let contain = UIView()
        contain.translatesAutoresizingMaskIntoConstraints = false
        contain.backgroundColor = .white
        let labelTitle = Reusable.makeLabel(text: title,
                                            font: .systemFont(ofSize: 14, weight: .regular),
                                            color: UIColor(named: "darkKasumi")!,
                                            numberOfLines: 0, alignment: .left)
        contain.addSubviews(views: labelTitle)
        labelTitle.centerY(toAnchor: contain.centerYAnchor)
        labelTitle.left(toAnchor: contain.leftAnchor, space: 10)
        labelTitle.right(toAnchor: contain.rightAnchor, space: 10)
        
        return contain
    }
    
    lazy var item1 = createItemView(title: "Address cannot be found".localiz())
    lazy var item2 = createItemView(title: "Person not at home".localiz())
    lazy var item3 = createItemView(title: "Package not correct".localiz())
    lazy var item4 = createItemView(title: "I have an accidents".localiz())
    lazy var item5 = createItemView(title: "Others".localiz())
    
    let imageCekist = Reusable.makeImageView(image: UIImage(named: "ceklist"), contentMode: .scaleAspectFit)
    
    let submitButton: UIButton={
        let button = UIButton()
        button.setTitle("Submit".localiz(), for: .normal)
        button.backgroundColor = UIColor(named: "orangeKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton={
        let button = UIButton()
        button.setTitle("Cancel".localiz(), for: .normal)
        button.backgroundColor = UIColor(named: "darkKasumi")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular )
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()

    lazy var note: UITextView = {
       let tv = UITextView()
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.returnKeyType = .continue
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        tv.layer.shadowOpacity = 0.5
        tv.backgroundColor = .white
        tv.dataDetectorTypes = .all
        tv.textAlignment = .left
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        tv.isHidden = true
        tv.text = messages[0]
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(views: scrollView)
        
        configureNavigationBar()
        configureLayout()
        constraint1 = submitButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20)
        constraint2 = submitButton.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 20)
        constraint1.isActive = true
        constraint2.isActive = false
        c1 = imageCekist.centerYAnchor.constraint(equalTo: item1.centerYAnchor)
        c2 = imageCekist.centerYAnchor.constraint(equalTo: item2.centerYAnchor)
        c3 = imageCekist.centerYAnchor.constraint(equalTo: item3.centerYAnchor)
        c4 = imageCekist.centerYAnchor.constraint(equalTo: item4.centerYAnchor)
        c5 = imageCekist.centerYAnchor.constraint(equalTo: item5.centerYAnchor)
        c1.isActive = true
        c2.isActive = false
        c3.isActive = false
        c4.isActive = false
        c5.isActive = false
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
            })
        case .willHide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
        container.dropShadow(color: .blue, opacity: 0.1, offSet: CGSize(width: 0, height: 0), radius: 5, scale: true)
        item1.roundCorners([.topLeft, .topRight], radius: 5)
        item5.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        let items = [item1,item2,item3,item4, item5]
        _ = items.enumerated().map { (i, e) in
            e.addBorder(toSide: .Top, withColor: UIColor.rgba(red: 0, green: 0, blue: 0,alpha: 0.1).cgColor, andThickness: 1)
        }
        
        item1.addBorder(toSide: .Top, withColor: UIColor.rgba(red: 0, green: 0, blue: 0,alpha: 0).cgColor, andThickness: 1)

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
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.left(toAnchor: view.leftAnchor)
        stackView.right(toAnchor: view.rightAnchor)
        stackView.height(view.frame.height)
        stackView.top(toAnchor: scrollView.topAnchor)
        
        stackView.addSubviews(views: titleLebel, container, submitButton, cancelButton, note)
        container.addSubviews(views: item1, item2, item3, item4, item5, imageCekist)
        
        titleLebel.translatesAutoresizingMaskIntoConstraints = false
        titleLebel.top(toAnchor: stackView.topAnchor, space: 20)
        titleLebel.left(toAnchor: view.leftAnchor, space: 10)
        titleLebel.right(toAnchor: view.rightAnchor, space: -10)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.top(toAnchor: titleLebel.bottomAnchor, space: 20)
        container.left(toAnchor: view.leftAnchor, space: 10)
        container.right(toAnchor: view.rightAnchor, space: -10)
        
        imageCekist.translatesAutoresizingMaskIntoConstraints = false
        imageCekist.right(toAnchor: container.rightAnchor, space: -10)
        imageCekist.width(14)
        imageCekist.height(14)
        
    
        let items = [item1,item2,item3,item4, item5]
        _ = items.enumerated().map { (i, e) in
            e.backgroundColor = .clear
            e.translatesAutoresizingMaskIntoConstraints = false
            if i != items.count-1 {
                e.isUserInteractionEnabled = true
                let tap = CustomTap(target: self, action: #selector(tapQuickChat))
                tap.ourCustomValue = i
                e.addGestureRecognizer(tap)
            }
            e.left(toAnchor: container.leftAnchor)
            e.right(toAnchor: container.rightAnchor)
            e.height(45)
        }
        
        item5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOther)))
        
        item1.top(toAnchor: container.topAnchor)
        item2.top(toAnchor: item1.bottomAnchor,space: 1)
        item3.top(toAnchor: item2.bottomAnchor,space: 1)
        item4.top(toAnchor: item3.bottomAnchor,space: 1)
        item5.top(toAnchor: item4.bottomAnchor,space: 1)
        item5.bottom(toAnchor: container.bottomAnchor)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        note.translatesAutoresizingMaskIntoConstraints = false
        
        note.top(toAnchor: container.bottomAnchor, space: 24)
        note.height(80)
        note.left(toAnchor: view.leftAnchor, space: 10)
        note.right(toAnchor: view.rightAnchor, space: -10)
        
        submitButton.top(toAnchor: note.bottomAnchor, space: 20)
        cancelButton.top(toAnchor: note.bottomAnchor, space: 20)
        cancelButton.right(toAnchor: view.rightAnchor, space: -10)
        cancelButton.width(100)
        submitButton.left(toAnchor: view.leftAnchor, space: 10)
        submitButton.right(toAnchor: cancelButton.leftAnchor, space: -10)
        cancelButton.height(45)
        submitButton.height(45)
    }
    
    @objc private func tapOther(){
        note.becomeFirstResponder()
        note.text = ""
        note.isHidden = false
        constraint2.isActive = true
        constraint1.isActive = false
        
        c1.isActive = false
        c2.isActive = false
        c3.isActive = false
        c4.isActive = false
        c5.isActive = true
    }
    
    @objc private func didTapView(){
        view.endEditing(true)
    }
    
    @objc func tapQuickChat(sender: CustomTap){
        guard let index = sender.ourCustomValue as? Int else {
            return
        }
        didTapView()
        note.text = messages[index]
        note.isHidden = true
        constraint2.isActive = false
        constraint1.isActive = true
        
        c1.isActive = index == 0
        c2.isActive = index == 1
        c3.isActive = index == 2
        c4.isActive = index == 3
        c5.isActive = index == 4
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Pending Delivery".localiz()
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
