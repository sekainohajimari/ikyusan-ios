import UIKit
import ObjectMapper
import Bond

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
    
    var identifier              = Dynamic<Int>(0)
    var notifierId              = Dynamic<Int>(0)
    var type                    = Dynamic<String>("")
    var notificationableType    = Dynamic<String>("")
    var notificationableId      = Dynamic<String>("")
    var notificationKind        = Dynamic<Int>(0)
    var progress                = Dynamic<Int>(0)
    var createdAt               = Dynamic<String>("")
    var updatedAt               = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier              <- map["id"]
        notifierId              <- map["notifier_id"]
        type                    <- map["type"]
        notificationableType    <- map["notificationable_type"]
        notificationableId      <- map["notificationable_id"]
        notificationKind        <- map["notification_kind"]
        progress                <- map["progress"]
        createdAt               <- map["created_at"]
        updatedAt               <- map["updated_at"]
    }
}