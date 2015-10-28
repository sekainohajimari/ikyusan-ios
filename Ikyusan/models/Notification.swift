import UIKit
import ObjectMapper
import Bond

class Notification: Mappable {

    var identifier          = Observable<Int>(0)
    var title               = Observable<String>("")
    var body                = Observable<String>("")
    var opened              = Observable<Bool>(false)
    var createdAt           = Observable<String>("")

    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        title.value           <- map["title"]
        body.value            <- map["body"]
        opened.value          <- map["opened"]
        createdAt.value       <- map["created_at"]
    }
}