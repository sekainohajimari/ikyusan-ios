//
//  Member.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Member: Mappable {

    var identifier  = Dynamic<Int>(0)
    var role        = Dynamic<String>("")
    var status      = Dynamic<String>("")
    var user        = User()
    var createdAt   = Dynamic<String>("")
    var updatedAt   = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        role.value            <- map["role"]
        status.value          <- map["status"]
        user                  <- map["user"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
