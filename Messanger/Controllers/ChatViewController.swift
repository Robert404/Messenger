//
//  ChatViewController.swift
//  Messanger
//
//  Created by Robert Nersesyan on 13.07.21.
//

import UIKit
import MessageKit

struct Message: MessageType {
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    
    var photoUrl: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let sender = Sender(photoUrl: "", senderId: "1", displayName: "Thomas")

    override func viewDidLoad() {
        super.viewDidLoad()
        messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello first message")))
        view.backgroundColor = .red
        
        messagesCollectionView.dataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
}
