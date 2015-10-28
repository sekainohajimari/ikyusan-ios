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

    var identifier  = Observable<Int>(0)
    var profile     = Profile()
    var createdAt   = Observable<String>("")
    var updatedAt   = Observable<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        profile               <- map["profile"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
