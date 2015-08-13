//
//  Group.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

enum GroupType :String {
    case Join      = "joining"      // 参加済み
    case Invited   = "inviting"     // 招待されているところ
}

class Group: Mappable {

    var identifier      = Dynamic<Int>(0)
    var name            = Dynamic<String>("")
    var membarMaxNum    = Dynamic<Int>(0)
    var topicMaxNum     = Dynamic<Int>(0)
    var colorCodeId     = Dynamic<Int>(GroupColor.Red.rawValue)
    var groupMembers    = [Member]()

    var hasOwner        = Dynamic<Bool>(false)
    var status          = Dynamic<GroupType>(GroupType.Join)

    var createdAt       = Dynamic<String>("")
    var updatedAt       = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init() {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        name.value            <- map["name"]
        membarMaxNum.value    <- map["membar_max_num"]
        topicMaxNum.value     <- map["topic_max_num"]
        colorCodeId.value     <- map["color.color_code_id"]
        groupMembers          <- map["group_members"]
        
//        Mapper<Group>().mapArray(dictionary["groups"])

//        hasOwner.value        = (map["own_group_member.role"].value() == "owner")
        status.value          = GroupType(rawValue:map["own_group_member.status"].valueOr(GroupType.Invited.rawValue))!

        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }

//    private func hasOwner() -> Bool {
//        return false
//    }
}
