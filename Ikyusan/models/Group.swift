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
    case Join           = "joining"      // 参加済み
    case Invited        = "inviting"     // 招待されているところ
    case Withdrawaling  = "withdrawaling"     // 招待されているところ
}

class Group: Mappable {

    var identifier      = Observable<Int>(0)
    var name            = Observable<String>("")
    var membarMaxNum    = Observable<Int>(0)
    var topicMaxNum     = Observable<Int>(0)
    var colorCodeId     = Observable<Int>(GroupColor.Red.rawValue)
    var groupMembers    = [Member]()

    var hasOwner        = Observable<Bool>(false)
    var status          = Observable<GroupType>(GroupType.Join)

    var createdAt       = Observable<String>("")
    var updatedAt       = Observable<String>("")
    
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

        hasOwner.value        = self.getIsOwner()
        status.value          = GroupType(rawValue:map["own_group_member.status"].valueOr(GroupType.Invited.rawValue))!

        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }

    private func getIsOwner() -> Bool {
        if let userId = AccountHelper.sharedInstance.getUserId() {
            for member in self.groupMembers {
                if member.user.identifier.value == userId {
                    if member.role.value == "owner" {
                        return true
                    }
                    return false
                }
            }
        }
        return false
    }
}
