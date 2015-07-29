//
//  Signup.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/20.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Signup: Mappable {

    var identifier  = Dynamic<Int>(0)
    var token       = Dynamic<String>("")
    var profile     = Profile()

    required init?(_ map: Map) {
        mapping(map)
    }

    init() {
        //
    }

    func mapping(map: Map) {
        identifier.value    <- map["id"]
        token.value         <- map["token"]
        profile             <- map["profile"]
    }

}
