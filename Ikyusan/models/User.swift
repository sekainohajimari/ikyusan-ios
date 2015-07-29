//
//  User.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class User: Mappable {
   
    var identifier  = Dynamic<Int>(0)
    var provider    = Dynamic<String>("")
    var uid         = Dynamic<String>("")
    var screenName  = Dynamic<String>("")
    var screenUrl   = Dynamic<String>("")
    var status      = Dynamic<Int>(0)
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
        provider.value        <- map["provider"]
        uid.value             <- map["uid"]
        screenName.value      <- map["screen_name"]
        screenUrl.value       <- map["screen_url"]
        status.value          <- map["status"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
