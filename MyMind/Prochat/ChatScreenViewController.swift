//
//  ChatScreenViewController.swift
//  MyMind
//
//  Created by STDC_41 on 20/05/2024.
//

import UIKit
import MessageKit

struct Sender:SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatScreenViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    let currentUser = Sender(senderId: "self", displayName: "Aizat")
    let otherUser = Sender(senderId: "other", displayName: "John")
    
    var currentSender: SenderType { currentUser }
    
    var messages = [MessageType]()

    override func viewDidLoad() {
        
        messages.append(Message(
            sender: currentUser,
            messageId: "1",
            sentDate: Date().addingTimeInterval(-86400),
            kind: .text("Hello. I'm John")))
        
        messages.append(Message(
            sender: otherUser,
            messageId: "2",
            sentDate: Date().addingTimeInterval(-80400),
            kind: .text("Hello John. I'm Dr. Farhan. I will be your therapist for this session. How are you feeling today? 😁")))
        
        messages.append(Message(
            sender: currentUser,
            messageId: "3",
            sentDate: Date().addingTimeInterval(-74400),
            kind: .text("Much better than last week, I feel like 🤔")))
        
        messages.append(Message(
            sender: otherUser,
            messageId: "4",
            sentDate: Date().addingTimeInterval(-68400),
            kind: .text("That's good. It's important to take a deep breath and relax")))
        
        messages.append(Message(
            sender: otherUser,
            messageId: "5",
            sentDate: Date().addingTimeInterval(-45400),
            kind: .text("Ready for our session today?")))
        
        messages.append(Message(
            sender: currentUser,
            messageId: "6",
            sentDate: Date().addingTimeInterval(-30400),
            kind: .text("Just a sec, I have a presentation to do 🫡")))

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        super.viewDidLoad()
        iconOnNavBar()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    private func iconOnNavBar(){
        let image = UIImage(systemName: "phone.fill")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = getAvatar(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
    
    private func getAvatar(sender: SenderType) -> Avatar{
        let therapistPic = UIImage(named: "Therapist")
        if sender.senderId == "other"{
            return Avatar(image: therapistPic, initials: "DrF")
        }
        else{
            return Avatar(image: nil, initials: "You")
        }
        
    }

}
