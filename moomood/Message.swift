import Foundation
import RealmSwift

class Message: Object{
    @objc dynamic var senderName = ""
    @objc dynamic var senderID = ""
    @objc dynamic var senderMessage = ""
}
