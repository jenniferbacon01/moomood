//
//  ChatbotViewController.swift
//  moomood
//
//  Created by Elizabeth Chan on 12/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import RealmSwift
import JSQMessagesViewController
import ApiAI

struct User {
    let id: String
    let name: String
}

class ChatbotViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    var user1 = User(id: "1", name: "Eli")
    var user2 = User(id: "2", name: "momoobot")
    
    var currentUser: User {
        return user1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //     self.navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view, typically from a nib.
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        // store message into JSXMessage array
        
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text!)
        
        messages.append(message!)
        
        finishSendingMessage()
            
        print("hello")
    }
    
    // formatting
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let messageUserName = message.senderDisplayName
        
        return NSAttributedString(string: messageUserName!)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    
}




