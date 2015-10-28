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

    var identifier       = Observable<Int>(0)
    var userId           = Observable<Int>(0)
    var displayId        = Observable<String>("")
    var displayName      = Observable<String>("")
    var createdAt        = Observable<String>("")
    var updatedAt        = Observable<String>("")
    var iconUrl          = Observable<String>("")
    var defaultIconUrl   = Observable<String>("")
    var inUseDefaultIcon = Observable<Bool>(false)
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }
    
    func mapping(map: Map) {
        identifier.value       <- map["id"]
        userId.value           <- map["user_id"]
        displayId.value        <- map["display_id"]
        displayName.value      <- map["display_name"]
        createdAt.value        <- map["created_at"]
        updatedAt.value        <- map["updated_at"]
        iconUrl.value          <- map["icon_url"]
        defaultIconUrl.value   <- map["default_icon_url"]
        inUseDefaultIcon.value <- map["in_use_default_icon"]
    }
}
