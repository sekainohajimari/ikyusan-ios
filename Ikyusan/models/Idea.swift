import UIKit
import ObjectMapper
import Bond

class Idea: Mappable {

    var identifier  = Dynamic<Int>(0)
    var topicId     = Dynamic<Int>(0)
    var postUser    = PostUser()
    var content     = Dynamic<String>("")
    var likeCount   = Dynamic<Int>(0)
    var anonymity   = Dynamic<Int>(0)
    var createdAt   = Dynamic<String>("")
    var updatedAt   = Dynamic<String>("")
    
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
