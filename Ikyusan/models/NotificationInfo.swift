import UIKit
import ObjectMapper
import Bond

class NotificationInfo: Mappable {
    
    var meta                = NotificationMeta()
    var notifications       = [Notification]()

    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }

    func mapping(map: Map) {
        meta            <- map["meta.pagination"]
        notifications   <- map["notifications"]
    }
}
