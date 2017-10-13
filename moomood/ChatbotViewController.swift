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
    
    // setting variables
    var messages = [JSQMessage]()
    var user1 = User(id: "1", name: "Elizabeth")
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
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarController?.tabBar.isHidden = true
        //     self.navigationController?.isNavigationBarHidden = false
        
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        
        self.queryAllMessages()
    }
    
    // sending the message
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date) {
        
        print("Date : \(date)")
        
        // store message into Realm
        self.addMessage(senderDisplayName, senderID: senderId, senderMessage: text)

        // store message into JSXMessage array
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text!)
        
        messages.append(message!)
        
        handleSendMessageToBot(text)
        
        finishSendingMessage()
    }
    
    // style formatting
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
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
    
    // define a new function to save data to Realm
    func addMessage(_ senderName: String, senderID: String, senderMessage: String) {
        // class Message
        let message = Message()
        message.senderID = senderID
        message.senderName = senderName
        message.senderMessage = senderMessage
        
        // write to Realm
        let realm = try! Realm()
        try! realm.write {
            realm.add(message)
        }
    }
    
    // define a new function to extract data from Realm
    func queryAllMessages(){
        let realm = try! Realm()
        let messages = realm.objects(Message.self)
        
        // for every message saved in realm
        for message in messages {
            
            // convert each message to a JSQMessage
            let msg = JSQMessage(senderId: message.senderID, displayName: message.senderName, text: message.senderMessage)
            // append it to the JSQMessage array
            self.messages.append(msg!)
        }
    }
    
    // handle sending message to and receiving response from chatbot's api
    func handleSendMessageToBot(_ message: String) {
        let request = ApiAI.shared().textRequest()
        request?.query = message
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            //handle response from chatbot's api
            let response = response as! AIResponse
            
            if let responseFromAI = response.result.fulfillment.speech as? String {
                self.handleStoreBotMsg(responseFromAI)
            }
            
        }, failure: { (request, error) in
            print(error!)
        })
        
        // send message to chatbot api
        ApiAI.shared().enqueue(request)
    }
    
    // handle receiving message from chatbot's api
    func handleStoreBotMsg(_ botMsg: String){
        
        // store message to local Realm
        addMessage(user2.name, senderID: user2.id, senderMessage: botMsg)
        
        // convert to JSQMessage
        let botMessage = JSQMessage(senderId: user2.id, displayName: user2.name, text: botMsg)
        
        //store into JSQMessage array
        messages.append(botMessage!)
        
        //update UI
        finishSendingMessage()
    }
    

}




