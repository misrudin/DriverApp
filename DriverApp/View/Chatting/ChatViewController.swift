//
//  ChatViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import UIKit
import AutoKeyboard

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        
        return dateFormater.date(from: customString) ?? Date()
    }
    
    static var yesterday: Date { return Date().dayBefore }
      static var tomorrow:  Date { return Date().dayAfter }
      var dayBefore: Date {
          return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
      }
      var dayAfter: Date {
          return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
      }
      var noon: Date {
          return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
      }
      var month: Int {
          return Calendar.current.component(.month,  from: self)
      }
      var isLastDayOfMonth: Bool {
          return dayAfter.month != month
      }
}

@available(iOS 13.0, *)
class ChatViewController: UIViewController {
    
    private let cellId = "id"
    var chatViewModel = ChatViewModel()
       
    var anchor1: NSLayoutConstraint!
    var anchor2: NSLayoutConstraint!
    var keyboardH: CGFloat = 280
    
    var chatMessages = [[ChatMessage]]()
    
    lazy var inputField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.placeholder = "Type your message here ..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        return field
    }()
    
    lazy var sendButton: UIButton={
        let btn = UIButton()
        let image = UIImage(named: "sendIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        btn.setImage(baru, for: .normal)
        btn.backgroundColor = UIColor(named: "orangeKasumi")
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(didSendMessage), for: .touchUpInside)
        return btn
    }()
    
    lazy var inputChat: UIView = {
        let v = UIView()
        v.addSubview(inputField)
        v.addSubview(sendButton)
        let border = UIView()
        v.addSubview(border)
        border.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2)
        border.anchor(top: v.topAnchor, left: v.leftAnchor, right: v.rightAnchor, height: 1)
        
        return v
    }()
    
    lazy var tableView: UITableView = {
       let table = UITableView()
        table.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
       return table
    }()
    
    lazy var imageButton: UIButton = {
       let button = UIButton()
        let btn = UIButton()
        let image = UIImage(named: "photoChat")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        button.setImage(baru, for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.blue, for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(presentPhotoActionSheet), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.isUserInteractionEnabled = true
//        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
//        tableView.estimatedRowHeight = 50
        listenData()
        view.addSubview(tableView)
        view.addSubview(inputChat)
        
        inputField.delegate = self
      
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,bottom: inputChat.topAnchor, right: view.rightAnchor)
        inputChat.anchor(left: view.leftAnchor, right: view.rightAnchor, height: 55)
        inputChat.addSubview(imageButton)
        
        imageButton.anchor(top: inputChat.topAnchor, left: inputChat.leftAnchor, paddingLeft: 16, width: 45, height: 45)
        
        inputField.anchor(left: imageButton.rightAnchor, right: sendButton.leftAnchor, paddingLeft: 10, paddingRight: 10,height: 45)
        
        inputField.centerYAnchor.constraint(equalTo: inputChat.centerYAnchor).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: inputChat.centerYAnchor).isActive = true
        sendButton.anchor(right: inputChat.rightAnchor, paddingRight: 16, width: 45,height: 45)
        sendButton.centerYAnchor.constraint(equalTo: inputChat.centerYAnchor).isActive = true
        
        anchor1 = inputChat.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        anchor1.isActive = true
        anchor2 = inputChat.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -(keyboardH-10))
        anchor2.isActive = false
    }
    
    
    @objc private func tap(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerAutoKeyboard() { (result) in
            
            if let k = result.userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = k.cgRectValue.height
                
                self.keyboardH = keyboardRectangle
            }
            

        switch result.status {
        case .willShow:
        print("1")
        case .didShow:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                
                self.anchor1.isActive = false
                self.anchor2.isActive = true
            })
        case .willHide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.anchor1.isActive = true
                self.anchor2.isActive = false
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

    @objc
    func didSendMessage(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let chat = inputField.text, chat != "" else {
            print("No user data")
            return
        }
        
        chatViewModel.sendMessage(codeDriver: codeDriver,chat: chat) {[weak self] (result) in
            if result {
                print("Success To send Messages")
            }else {
                print("Failed to send messages")
            }
            self?.inputField.text = ""
        }
    }
    
    func sendFotoMessage(image: UIImage){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageString = imageData?.base64EncodedString()
        
        chatViewModel.sendMessage(codeDriver: codeDriver, foto: imageString!) { (result) in
            if result {
                print("Success To send Foto")
            }else {
                print("Failed to send Foto")
            }
        }
    }
    
    
    func listenData(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
        chatViewModel.getAllMsssages(codeDriver: codeDriver) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.chatMessages = data
                    self.tableView.reloadData()
                    let indexPath = NSIndexPath(item: data.last!.count-1, section: data.count-1)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Customer Service"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }

}

@available(iOS 13.0, *)
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return chatMessages.count
       }
       
       class DateHeaderLabel: UILabel {
           
           override init(frame: CGRect) {
               super.init(frame: frame)
               backgroundColor = .black
               textColor = .white
               textAlignment = .center
               translatesAutoresizingMaskIntoConstraints = false
               font = UIFont.boldSystemFont(ofSize: 14)
           }
           
           required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
           
           override var intrinsicContentSize: CGSize{
               let originalContentSize = super.intrinsicContentSize
               let height = originalContentSize.height + 10
               layer.cornerRadius = height / 2
               layer.masksToBounds = true
               return CGSize(width: originalContentSize.width + 20, height: height)
           }
       }
       
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if let firstIndexInMessage = chatMessages[section].first{
               let dateFormater = DateFormatter()
               dateFormater.dateFormat = "yyyy/MM/dd"
               let dateString = dateFormater.string(from: firstIndexInMessage.date)
            
                let dateStringYesterday = dateFormater.string(from: Date.yesterday)
                let dateStringNow = dateFormater.string(from: Date())
            
                let value = dateString == dateStringNow ? "Today" : dateString == dateStringYesterday ? "Yesterday" : dateString

               let label = DateHeaderLabel()
               label.text = value
               
               
               let containerLabel = UIView()
               containerLabel.addSubview(label)
               
               label.centerXAnchor.constraint(equalTo: containerLabel.centerXAnchor).isActive=true
               label.centerYAnchor.constraint(equalTo: containerLabel.centerYAnchor).isActive=true
               
               
               return containerLabel
           }
           
           return nil
       }
       
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
       }
              
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return chatMessages[section].count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! ChatCell
           let chatMessage = chatMessages[indexPath.section][indexPath.row]
           
           cell.chatMessage = chatMessage
           
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        tap()
        if chatMessage.photo != "" {
            let slideVC = PeviewPhoto()
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            slideVC.sendButton.isHidden = true
            slideVC.closeButton.isHidden = false
            if let stringPhoto = chatMessage.photo {
                let newImageData = Data(base64Encoded: stringPhoto)
                if let image = newImageData {
                    slideVC.image = UIImage(data: image)
                }
            }
            present(slideVC, animated: true, completion: nil)
        }
    }
}


@available(iOS 13.0, *)
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputField {
            didSendMessage()
        }
        return true
    }
}

//MARK: - EXTENSION
@available(iOS 13.0, *)
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Upload Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presetPhotoPicker()
                                            }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func presetPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(picker)
        picker.dismiss(animated: true, completion: nil)
        guard let selectdedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        
        let hasil = Helpers().resizeImageUpload(image: selectdedImage)
        
        
        let slideVC = PeviewPhoto()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.delegate = self
        slideVC.sendButton.isHidden = false
        slideVC.closeButton.isHidden = true
        slideVC.image = hasil
        present(slideVC, animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


@available(iOS 13.0, *)
extension ChatViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        Preview(presentedViewController: presented, presenting: presenting)
    }
}



@available(iOS 13.0, *)
class PeviewPhoto: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    weak var delegate: ChatViewController!
    
    var image: UIImage?
    
    let imageViewPreview: UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
       return iv
    }()
    
    let sendButton: UIButton = {
       let b = UIButton()
        b.setTitle("Send", for: .normal)
        b.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        b.clipsToBounds = true
        b.layer.masksToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return b
    }()
    
    let closeButton: UIButton = {
       let b = UIButton()
        b.setTitle("Close", for: .normal)
        b.setTitleColor(UIColor(named: "orangeKasumi"), for: .normal)
        b.clipsToBounds = true
        b.layer.masksToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor(named: "orangeKasumi")?.cgColor
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    
    @objc func sendMessage(){
        let imageToSend: UIImage = imageViewPreview.image!
        delegate.sendFotoMessage(image: imageToSend)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    
    let line: UIView = {
      let v = UIView()
        v.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.2)
        v.layer.cornerRadius = 2
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        view.addSubview(line)
        
        view.addSubview(imageViewPreview)
        view.addSubview(sendButton)
        view.addSubview(closeButton)
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        imageViewPreview.image = image
        line.anchor(top: view.topAnchor,paddingTop: 16, width: 100, height: 4)
        line.centerX(toView: view)
        
        imageViewPreview.anchor(top: line.bottomAnchor, left: view.leftAnchor,bottom: sendButton.topAnchor, right: view.rightAnchor, paddingTop: 16,paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        sendButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        
        closeButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 45)
    }
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    
}
