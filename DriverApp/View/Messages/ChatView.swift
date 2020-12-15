//
//  ChatView.swift
//  DriverApp
//
//  Created by Indo Office4 on 14/12/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import AVFoundation
import AVKit
import AlamofireImage

struct Pesan: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self{
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audion"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var photoUrl: String
    public var senderId: String
    public var displayName: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

@available(iOS 13.0, *)
class ChatView: MessagesViewController {
    
    var chatVm = ChatViewModel()
    
    public static let dateFormatter: DateFormatter = {
           let formater = DateFormatter()
           formater.dateStyle = .medium
           formater.timeStyle = .long
           formater.locale = .current
           
           return formater
       }()
    
    
    public let otherUserId:String = "17257"
    public var isNewConversation = false
    
    private var messages = [Pesan]()
    
    private var selfSender: Sender? {
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return nil
        }
        
        
        return Sender(photoUrl: "",
                      senderId: codeDriver,
                      displayName: "Me")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        listenMessage()
    }
    
    private func setupInputButton(){
           let button = InputBarButtonItem()
           button.setSize(CGSize(width: 35, height: 35), animated: false)
           button.setImage(UIImage(named: "photoChat"), for: .normal)
           button.onTouchUpInside{[weak self] _ in
               self?.presentPhotoInputActionsSheet()
           }
           
           messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
           messageInputBar.setStackViewItems([button],
                                             forStack: .left,
                                             animated: false)
       }
    
    
    //MARK: - PRESENT PHOTO ACTION SHEET
    private func presentPhotoInputActionsSheet(){
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach photo from ?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
//            picker.delegate = self
            picker.allowsEditing = true
            
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
//            picker.delegate = self
            picker.allowsEditing = true
            
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    
    private func listenMessage(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        
    //
    }

}


//MARK: - ESTENSION

@available(iOS 13.0, *)
extension ChatView: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
       //function for send message
    }
}

@available(iOS 13.0, *)
extension ChatView: MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Pesan else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            
            imageView.af.setImage(withURL: imageUrl)
        default:
            break
        }
        
    }
}


@available(iOS 13.0, *)
extension ChatView: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        //        message click
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            
          print(imageUrl)
            //muculkan preview image
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }
            
        let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
        present(vc, animated: true)
        default:
            break
        }
    }
}
