import UIKit
import ObjectMapper
import Bond

class Notification: Mappable {

    var identifier          = Dynamic<Int>(0)
    var title               = Dynamic<String>("")
    var body                = Dynamic<String>("")
    var opened              = Dynamic<Bool>(false)

    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        title           <- map["title"]
        body            <- map["body"]
        opened          <- map["opened"]
    }
}