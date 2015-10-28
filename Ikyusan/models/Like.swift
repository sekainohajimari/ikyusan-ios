//
//  Like.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Like: Mappable {
    
    var identifier  = Observable<Int>(0)
    var idea        = Idea()
    var likeUser    = User()
    var num         = Observable<Int>(0)
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
        idea                  <- map["idea"]
        likeUser              <- map["like_user"]
        num.value             <- map["num"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
