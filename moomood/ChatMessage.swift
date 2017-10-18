import Foundation
import RealmSwift

class ChatMessage: Object{
    
    @objc dynamic var senderName = ""
    @objc dynamic var senderID = ""
    @objc dynamic var senderMessage = ""
    @objc dynamic var senderMedia: Data? = nil
    
}
