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
    let googleApiKey = "AIzaSyBATKEWEvE2Uk95dofrHHht8yu9_v5Pgd8"
    let customSearchEngineID = "002936525752981635088:zeicz7g3ytc"
    var selectedImage: UIImage?
    var photoURL: String!
    var messages = [JSQMessage]()
    var user1 = User(id: "1", name: "You")
    var user2 = User(id: "2", name: "Moomoo")
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
        }
        return nil
    }
 
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
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.tabBarController?.tabBar.isHidden = true
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        self.queryAllMessages()
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.didPressSend(nil, withMessageText: self.keyboardController.textView?.text, senderId: user1.id, senderDisplayName: user1.name, date: Date())
        }
        return true
    }
    
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
    
    // define a new function to save data to Realm
    func addMessage(_ senderName: String, senderID: String, senderMessage: String) {
        let message = Message()
        message.senderID = senderID
        message.senderName = senderName
        message.senderMessage = senderMessage
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(message)
        }
    }
    
    // define a new function to extract data from Realm
    func queryAllMessages(){
        let realm = try! Realm()
        let messages = realm.objects(Message.self)
        
        // for every message saved in realm, append it to the JSQMessage array
        for message in messages {
            let msg = JSQMessage(senderId: message.senderID, displayName: message.senderName, text: message.senderMessage)
            self.messages.append(msg!)
        }
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
            
            //handle google api
            if let thisReason = (response.result.parameters as! Dictionary<String, AIResponseParameter>)["reason"], thisReason.stringValue != "" {
                if apiAction == "recordGoodMood" {
                    
                self.handleSearchYouTubeWith(thisReason.stringValue)
                print(thisReason.stringValue)
                }
            }
        }
        }
        }, failure: { (request, error) in
            print(error!)
        })
        // send message to chatbot api
        ApiAI.shared().enqueue(request)
    }

// define a new function to handle google meme search
    func handleSearchYouTubeWith(_ reason: String){
        let urlString: String = "https://www.googleapis.com/customsearch/v1?key=\(googleApiKey)&cx=\(customSearchEngineID)&q=weird%20funny%20\(reason)%20meme&searchType=image"
        
        let targetURL = URL(string: urlString)
        
        performGetRequest(targetURL: targetURL!) { (data, HTTPStatusCode, error) in
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    let resultDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                    let items = resultDictionary["items"] as! Array<Dictionary<String, AnyObject>>
                    self.photoURL = items.first?["link"] as! String
                    self.sendPhotoToUser(self.photoURL)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func performGetRequest(targetURL: URL, completion: @escaping (_ data: Data?, _ HTTPStatusCode: Int, _ error: Error?) -> Void){
        
        // build Request
        var request = URLRequest(url: targetURL)
        request.httpMethod = "GET"
        
        // session
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            completion(data, (response as! HTTPURLResponse).statusCode, error)
        }
        task.resume()
    }
    
    // define a new function to save data to Realm
    func addMood(_ date: String, rating: Int, cause: String, moodDescription: String, others: String) {
        let mood = Mood()
        mood.date = date
        mood.rating = rating
        mood.cause = cause
        mood.moodDescription = moodDescription
        mood.others = others
        
        // write to Realm
        let realm = try! Realm()
        try! realm.write {
            realm.add(mood)
        }
    }
  
    // handle receiving message from chatbot's api
    func handleStoreBotMsg(_ botMsg: String){
        // store message to local Realm
        addMessage(user2.name, senderID: user2.id, senderMessage: botMsg)
        let botMessage = JSQMessage(senderId: user2.id, displayName: user2.name, text: botMsg)
        messages.append(botMessage!)
        finishSendingMessage()
    }
    
    func sendPhotoToUser(_ rawURL: String){
        //convert raw photo url into JSQPhotoMediaItem
        let url = URL(string: rawURL)
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        let data = try! Data(contentsOf: url! as URL) as Data!
        let mediaItem = JSQPhotoMediaItem(image: UIImage(data: data!))
        mediaItem?.appliesMediaViewMaskAsOutgoing = false
        
        // convert photo message to JSX format and add to JSXMessage array
        self.addPhotoMessage(_senderName: senderDisplayName, senderID: senderId, mediaItem: mediaItem!)
        
        finishSendingMessage()
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
    
    

}


