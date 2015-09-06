import UIKit
import ObjectMapper
import Bond

class NotificationMeta: Mappable {
    var currentPage          = Dynamic<Int>(0)
    var nextPage             = Dynamic<Int>(0)
    var prevPage             = Dynamic<Int>(0)
    var totalPages           = Dynamic<Int>(0)
    var totalCount           = Dynamic<Int>(0)

    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }

    func mapping(map: Map) {
        currentPage.value         <- map["current_page"]
        nextPage.value            <- map["next_page"]
        prevPage.value            <- map["prev_page"]
        totalPages.value          <- map["total_pages"]
        totalCount.value          <- map["total_count"]
    }
}
