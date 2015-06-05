import UIKit
import ObjectMapper

class Notification: Mappable {
    /*
    #  id                    :integer          not null, primary key
    #  notifier_id           :integer
    #  type                  :string(255)
    #  notificationable_type :string(255)
    #  notificationable_id   :string(255)
    #  notification_kind     :integer
    #  progress              :integer
    #  created_at            :datetime         not null
    #  updated_at            :datetime         not null
    */
    
//    var identifier  : Int?
//    var ideaId      : Int?
//    var likerId     : Int?
//    var num         : Int?
//    var createdAt   : String?
//    var updatedAt   : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
//        identifier      <- map["id"]
//        ideaId          <- map["idea_id"]
//        likerId         <- map["liker_id"]
//        num             <- map["num"]
//        createdAt       <- map["created_at"]
//        updatedAt       <- map["updated_at"]
    }
}