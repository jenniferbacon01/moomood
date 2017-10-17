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
    var user1 = User(id: "1", name: "You")
    var user2 = User(id: "2", name: "moomooBot")
    var currentUser: User {
        return user1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    
    func getImage(indexPath: IndexPath) -> UIImage? {
        let message = self.messages[indexPath.row]
        if message.isMediaMessage == true {
            let mediaItem = message.media
            if mediaItem is JSQPhotoMediaItem {
                let photoItem = mediaItem as! JSQPhotoMediaItem
                if let test: UIImage = photoItem.image {
                    let image = test
                    return image
                }
            }
//            if mediaItem is JSQVideoMediaItem {
//                let videoItem = mediaItem as! JSQVideoMediaItem
//                let videoURL = videoItem.fileURL
//            }
            
        }
        return nil
    }

    var selectedImage: UIImage?
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        if let test = self.getImage(indexPath: indexPath) {
            selectedImage = test
            self.performSegue(withIdentifier: "showMedia", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMedia" {
            if let pageDeDestination = segue.destination as? ShowMediaViewController {
                pageDeDestination.image = selectedImage!
            } else {
                print("type destination not ok")
            }
        } else {
            print("segue inexistant")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        
        self.queryAllMessages()
        
    }
    
    // what to happen when the send button is clicked
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
        return 20
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .lightGray)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .purple)
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
    
    // handle sending request and receiving response to/from chatbot's api
    func handleSendMessageToBot(_ message: String) {

        var newMood: String!
        var newReason: String!
        var newDate: String!
        var autoRating: Int!
        var mood: String!
        
        let request = ApiAI.shared().textRequest()
        request?.query = message
        
        // send request and receive response from chatbot api
        request?.setMappedCompletionBlockSuccess({ (request, response) in
         
        //handle response from chatbot's api
        let response = response as! AIResponse
     
        if let responseFromAI = response.result.fulfillment.messages.first?["speech"] as? String {
            
        // store response message to local Realm, convert to JSQMessage, store into JSQMessage array, update UI
        self.handleStoreBotMsg(responseFromAI)
            
        // import response paramaters into Realm
        let apiAction = response.result.action
            
        if apiAction == "recordGoodMood" || apiAction == "recordBadMood" || apiAction == "recordNeutralMood" {
            if let parameters = response.result.parameters as? [String: AIResponseParameter]{
                if apiAction == "recordGoodMood" {
                    mood = parameters["feelings"]!.stringValue
                } else if apiAction == "recordBadMood" {
                    mood = parameters["bad_feelings"]!.stringValue
                }
                let reason = parameters["reason"]!.stringValue
                let date = parameters["date"]!.stringValue
                
                newMood = mood?.replacingOccurrences(of: "[\n() ]", with: "", options: .regularExpression, range: nil)
                newReason = reason?.replacingOccurrences(of: "[\n() ]", with: "", options: .regularExpression, range: nil)
                newDate = date?.replacingOccurrences(of: "[\n() ]", with: "", options: .regularExpression, range: nil)
            }
                    
            //date formatter
            let unformattedDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: unformattedDate)
            if newDate! == "today" {
                newDate = formattedDate
            }
            if apiAction == "recordGoodMood" {
                autoRating = 4
            } else if (apiAction == "recordBadMood") {
                autoRating = 2
            } else if (apiAction == "recordNeutralMood") {
                autoRating = 3
            }
            if newMood! != "" && newReason! != "" {
                self.addMood(newDate!, rating: autoRating, cause: newReason!, moodDescription: newMood!, others: "")
            }
        }
            
        // print(newMood!)
        }
        }, failure: { (request, error) in
            print(error!)
        })
        // send message to chatbot api
        ApiAI.shared().enqueue(request)
    }


// define a new function to save data to Realm
    func addMood(_ date: String, rating: Int, cause: String, moodDescription: String, others: String) {
    // class Message
    let moodDB = MoodDB()
    moodDB.date = date
    moodDB.rating = rating
    moodDB.cause = cause
    moodDB.moodDescription = moodDescription
    moodDB.others = others
        
    
    // write to Realm
    let realm = try! Realm()
    try! realm.write {
        realm.add(moodDB)
    }
}
  
    // handle receiving message from chatbot's api
    func handleStoreBotMsg(_ botMsg: String){
        
        // store message to local Realm
        addMessage(user2.name, senderID: user2.id, senderMessage: botMsg)
        
        // convert to JSQMessage
        let botMessage = JSQMessage(senderId: user2.id, displayName: user2.name, text: botMsg)
        
        //store into JSQMessage array
        messages.append(botMessage!)
        
        let rawPhotoURL = "https://static.pexels.com/photos/20787/pexels-photo.jpg"
        sendPhotoToUser(rawPhotoURL)
        
//        let rawVideoURL = "https://www.youtube.com/watch?v=5dsGWM5XGdg"
//        sendVideoToUser(rawVideoURL)
        
        //update UI
        finishSendingMessage()
    }
    
    func sendPhotoToUser(_ rawURL: String){
        //convert raw photo url into JSQPhotoMediaItem
        let url = URL(string: rawURL)
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        let data = try! Data(contentsOf: url! as URL) as Data!
        let mediaItem = JSQPhotoMediaItem(image: UIImage(data: data!))
        
        // convert photo message to JSX format and add to JSXMessage array
        self.addPhotoMessage(_senderName: senderDisplayName, senderID: senderId, mediaItem: mediaItem!)
    }
    
    func sendVideoToUser(_ rawURL: String){
        //convert raw photo url into JSQPhotoMediaItem
        let url = URL(string: rawURL)
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        let data = try! Data(contentsOf: url! as URL) as Data!
        let mediaItem = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
        
        // convert photo message to JSX format and add to JSXMessage array
        self.addVideoMessage(_senderName: senderDisplayName, senderID: senderId, mediaItem: mediaItem!)
    }
    
    
    func readApiAction(_ botAction: String){
        if (botAction == "recordThisMood") {
            print("please record")
        } else {
            print("please do not record")
        }
    }
    
    // convert photo message to JSX format and add to JSXMessage array
    func addPhotoMessage(_senderName: String, senderID: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: user2.id, displayName: user2.name, media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                //photoMessageMap[key] = mediaItem
            }
            collectionView.reloadData()
        }
    }
    // convert video message to JSX format and add to JSXMessage array
    func addVideoMessage(_senderName: String, senderID: String, mediaItem: JSQVideoMediaItem) {
        if let message = JSQMessage(senderId: user2.id, displayName: user2.name, media: mediaItem) {
            messages.append(message)

            collectionView.reloadData()
        }
    }
    
   
}

//if message.isMediaMessage {
//    if message.media.isKind(of: JSQPhotoMediaItem.self) {
//        //Handle image
//        let mediaItem = message.media
//        let photoItem = mediaItem as! JSQPhotoMediaItem
//        if let test: UIImage = photoItem.image {
//            let image = test
//            return image
//        }
//
//    } else if message.media.isKind(of: JSQVideoMediaItem.self) {
//        let video = message.media as! JSQVideoMediaItem
//        let videoURL = video.fileURL
//    }
//}


//var photoMessageMap = [String: JSQPhotoMediaItem]()
//
//let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
//let photoItem = JSQPhotoMediaItem(image: UIImage(data: data!))
//let photoMessage = JSQMessage(senderId: AvatarIdWoz, displayName: getName(User.Wozniak), media: photoItem)
//
//self.addMedia(photoItem)
//
//func addMedia(_ media:JSQMediaItem, senderName: String, senderID: String) {
//    let message = JSQMessage(senderId: senderID, displayName: senderName, media: media)
//    messages.append(message!)
//
//    //Optional: play sent sound
//
//    finishSendingMessage(animated: true)
//}



//NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:entity.image.imageUrl]];
//UIImage *imageFromUrl = [UIImage imageWithData:data];
//JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:imageFromUrl];
//JSQMessage *photoMessage = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:displayName date:entity.messageDate media:photoItem];


//              print(response.result.parameters)
//                print(response.result.parameters["mood"])
//                print((response.result.parameters as? NSDictionary)?["mood"] as? AIResponseParameter!)


// DEMO:
//var copyMessage = self.messages.last?.copy()
//
//if (copyMessage == nil) {
//    copyMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), text: "First received!")
//}
//var newMessage:JSQMessage!
//var newMediaData:JSQMessageMediaData!
//var newMediaAttachmentCopy:AnyObject?
//
//if (copyMessage! as AnyObject).isMediaMessage() {
//    /**
//     *  Last message was a media message
//     */
//    let copyMediaData = (copyMessage! as AnyObject).media
//
//    switch copyMediaData {
//    case is JSQPhotoMediaItem:
//        let photoItemCopy = (copyMediaData as! JSQPhotoMediaItem).copy() as! JSQPhotoMediaItem
//        photoItemCopy.appliesMediaViewMaskAsOutgoing = false
//
//        newMediaAttachmentCopy = UIImage(cgImage: photoItemCopy.image!.cgImage!)
//
//        /**
//         *  Set image to nil to simulate "downloading" the image
//         *  and show the placeholder view5017
//         */
//        photoItemCopy.image = nil;
//
//        newMediaData = photoItemCopy
//    case is JSQLocationMediaItem:
//        let locationItemCopy = (copyMediaData as! JSQLocationMediaItem).copy() as! JSQLocationMediaItem
//        locationItemCopy.appliesMediaViewMaskAsOutgoing = false
//        newMediaAttachmentCopy = locationItemCopy.location!.copy() as AnyObject?
//
//        /**
//         *  Set location to nil to simulate "downloading" the location data
//         */
//        locationItemCopy.location = nil;
//
//        newMediaData = locationItemCopy;
//    case is JSQVideoMediaItem:
//        let videoItemCopy = (copyMediaData as! JSQVideoMediaItem).copy() as! JSQVideoMediaItem
//        videoItemCopy.appliesMediaViewMaskAsOutgoing = false
//        newMediaAttachmentCopy = (videoItemCopy.fileURL! as NSURL).copy() as AnyObject?
//
//        /**
//         *  Reset video item to simulate "downloading" the video
//         */
//        videoItemCopy.fileURL = nil;
//        videoItemCopy.isReadyToPlay = false;
//
//        newMediaData = videoItemCopy;
//    case is JSQAudioMediaItem:
//        let audioItemCopy = (copyMediaData as! JSQAudioMediaItem).copy() as! JSQAudioMediaItem
//        audioItemCopy.appliesMediaViewMaskAsOutgoing = false
//        newMediaAttachmentCopy = (audioItemCopy.audioData! as NSData).copy() as AnyObject?
//
//        /**
//         *  Reset audio item to simulate "downloading" the audio
//         */
//        audioItemCopy.audioData = nil;
//
//        newMediaData = audioItemCopy;
//    default:
//        assertionFailure("Error: This Media type was not recognised")
//    }
//
//    newMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), media: newMediaData)
//}
//else {
//    /**
//     *  Last message was a text message
//     */
//
//    newMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), text: (copyMessage! as AnyObject).text)
//}



