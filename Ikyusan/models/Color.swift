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

class Color: Mappable {

    var colorCodeId = Dynamic<Int>(0)

    required init?(_ map: Map) {
        mapping(map)
    }

    init() {
        //
    }

    func mapping(map: Map) {
        colorCodeId.value <- map["color_code_id"]
    }
}
