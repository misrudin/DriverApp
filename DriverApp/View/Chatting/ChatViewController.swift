//
//  ChatViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        listenData()
        view.addSubview(tableView)
        view.addSubview(inputChat)
        
        inputField.delegate = self
      
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,bottom: inputChat.topAnchor, right: view.rightAnchor)
        inputChat.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,height: 55)
        inputField.anchor(left: inputChat.leftAnchor, right: sendButton.leftAnchor, paddingLeft: 16, paddingRight: 10,height: 45)
        inputField.centerYAnchor.constraint(equalTo: inputChat.centerYAnchor).isActive = true
        sendButton.anchor(right: inputChat.rightAnchor, paddingRight: 16, width: 45,height: 45)
        sendButton.centerYAnchor.constraint(equalTo: inputChat.centerYAnchor).isActive = true
        
        
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))

        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))

        //We make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
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

@available(iOS 13.0, *)
extension ChatViewController {
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
        unsubscribeFromAllNotifications()
        inputChat.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

@available(iOS 13.0, *)
extension ChatViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        // Get required info out of the notification
        if  let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = tableView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
//            tableView.contentInset.bottom = keyboardOverlap
//            tableView.scrollIndicatorInsets.bottom = keyboardOverlap
            inputChat.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(keyboardOverlap+55)).isActive = true
            
            print(keyboardOverlap)
            print(endRect.origin.y)
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
