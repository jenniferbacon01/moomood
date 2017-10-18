import Foundation
import RealmSwift

class MediaMessage: Object{
    
    @objc dynamic var senderName = ""
    @objc dynamic var senderID = ""
    @objc dynamic var senderMessage = ""
    @objc dynamic var senderMedia: Data? = nil
    
}
