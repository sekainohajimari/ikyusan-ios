//
//  Profile.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Profile: Mappable {

    var prefix = ""

    var identifier      = Dynamic<Int>(0)
    var userId          = Dynamic<Int>(0)
    var displayId       = Dynamic<String>("")
    var displayName     = Dynamic<String>("")
    var createdAt       = Dynamic<String>("")
    var updatedAt       = Dynamic<String>("")
    var iconUrl         = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        userId.value          <- map["user_id"]
        displayId.value       <- map["display_id"]
        displayName.value     <- map["display_name"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
        iconUrl.value         <- map["icon_url"]
    }
}
