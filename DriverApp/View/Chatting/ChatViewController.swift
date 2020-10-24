//
//  ChatViewController.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import UIKit

struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        
        return dateFormater.date(from: customString) ?? Date()
    }
}

class ChatViewController: UITableViewController {
    
    private let cellId = "id"
       
       let chatMessages = [
           [
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/09/20")),
               ChatMessage(text: "Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan", isIncoming: false, date: Date.dateFromCustomString(customString: "2020/09/25") ),
           ],
           [
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/09/30")),
               ChatMessage(text: "Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan", isIncoming: false, date: Date.dateFromCustomString(customString: "2020/10/01")),
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/10/02")),
           ],
           [
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/10/03")),
               ChatMessage(text: "Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan", isIncoming: false, date: Date.dateFromCustomString(customString: "2020/10/04")),
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/10/04")),
           ],
           [
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/10/05")),
               ChatMessage(text: "Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan Ini adalah test untuk membuat pesan", isIncoming: false, date: Date.dateFromCustomString(customString: "2020/10/06")),
               ChatMessage(text: "Heloo This is my first messages", isIncoming: true, date: Date.dateFromCustomString(customString: "2020/10/07")),
           ]
       ]
    
//    private let inputChat=

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Chat With Admin"
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

       override func numberOfSections(in tableView: UITableView) -> Int {
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
       
       override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if let firstIndexInMessage = chatMessages[section].first{
               let dateFormater = DateFormatter()
               dateFormater.dateFormat = "yyyy/MM/dd"
               let dateString = dateFormater.string(from: firstIndexInMessage.date)

               let label = DateHeaderLabel()
               label.text = dateString
               
               
               let containerLabel = UIView()
               containerLabel.addSubview(label)
               
               label.centerXAnchor.constraint(equalTo: containerLabel.centerXAnchor).isActive=true
               label.centerYAnchor.constraint(equalTo: containerLabel.centerYAnchor).isActive=true
               
               
               return containerLabel
           }
           
           return nil
       }
       
       override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
       }
       
   //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   //        return "Section \(Date())"
   //    }
       
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return chatMessages[section].count
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! ChatCell
           let chatMessage = chatMessages[indexPath.section][indexPath.row]
           
           cell.chatMessage = chatMessage
           
           return cell
       }

}
