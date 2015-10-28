import UIKit
import ObjectMapper
import Bond

class Idea: Mappable {

    var identifier  = Observable<Int>(0)
    var topicId     = Observable<Int>(0)
    var postUser    = PostUser()
    var content     = Observable<String>("")
    var likeCount   = Observable<Int>(0)
    var anonymity   = Observable<Int>(0)
    var createdAt   = Observable<String>("")
    var updatedAt   = Observable<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        topicId.value         <- map["topic_id"]
        postUser              <- map["post_user"]
        content.value         <- map["content"]
        likeCount.value       <- map["likes_count"]
        anonymity.value       <- map["anonymity"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
