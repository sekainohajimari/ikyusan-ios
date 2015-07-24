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

    init(_ map: Map, prefix :String) {
        self.prefix = prefix + "."
        mapping(map)
    }

    init () {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map[prefix + "id"]
        userId.value          <- map[prefix + "user_id"]
        displayId.value       <- map[prefix + "display_id"]
        displayName.value     <- map[prefix + "display_name"]
        createdAt.value       <- map[prefix + "created_at"]
        updatedAt.value       <- map[prefix + "updated_at"]
        iconUrl.value         <- map[prefix + "icon_url"]
    }
}
