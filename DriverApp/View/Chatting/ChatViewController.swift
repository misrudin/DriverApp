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
        field.backgroundColor = UIColor.systemGray6
        return field
    }()
    
    lazy var sendButton: UIButton={
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        btn.backgroundColor = .link
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
        border.backgroundColor = UIColor.systemGray2
        border.anchor(top: v.topAnchor, left: v.leftAnchor, right: v.rightAnchor, height: 1)
        v.dropShadow(color: UIColor.systemGray6, opacity: 0.5, offSet: CGSize(width: 0, height: -2), radius: 1, scale: true)
        
        return v
    }()
    
    lazy var tableView: UITableView = {
       let table = UITableView()
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
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
        
        
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor,bottom: inputChat.topAnchor, right: view.rightAnchor)
        inputChat.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,height: 80)
        inputField.anchor(top: inputChat.topAnchor, left: inputChat.leftAnchor, bottom: inputChat.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 10, paddingBottom: 25, paddingLeft: 16, paddingRight: 10)
        sendButton.anchor(top: inputChat.topAnchor, bottom: inputChat.bottomAnchor, right: inputChat.rightAnchor, paddingTop: 10, paddingBottom: 25, paddingRight: 16, width: 45)
    }
    
    @objc
    func didSendMessage(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let chat = inputField.text else {
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
        navigationItem.title = "Chat With Customer Services"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didBack))
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didBack(){
        dismiss(animated: true, completion: nil)
    }

}

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


extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputField {
            didSendMessage()
        }
        return true
    }
}
