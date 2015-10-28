import UIKit
import ObjectMapper
import Bond

class NotificationMeta: Mappable {
    var currentPage          = Observable<Int>(0)
    var nextPage             = Observable<Int>(0)
    var prevPage             = Observable<Int>(0)
    var totalPages           = Observable<Int>(0)
    var totalCount           = Observable<Int>(0)

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
