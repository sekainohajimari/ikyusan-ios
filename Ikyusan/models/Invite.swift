import UIKit
import ObjectMapper
import Bond

class Invite: Mappable {

    var identifier  = Observable<Int>(0)
    var hostUser    = User()
    var inviteUser  = User()

    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }

    func mapping(map: Map) {
        identifier.value      <- map["id"]
        hostUser              <- map["host_user"]
        inviteUser            <- map["invite_user"]
    }
}