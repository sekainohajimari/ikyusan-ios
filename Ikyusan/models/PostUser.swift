//
//  Poster.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/24.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class PostUser: Mappable {

    var prefix = ""

    var identifier      = Dynamic<Int>(0)
    var profile         = Profile()

    required init?(_ map: Map) {
        mapping(map)
    }

    init(_ map: Map, prefix :String) {
        self.prefix = prefix + "."
        mapping(map)
    }

    init () {
            
    }

    func mapping(map: Map) {
        identifier.value      <- map[prefix + "id"]
        profile               = Profile(map, prefix: prefix + "profile")
    }
   
}
