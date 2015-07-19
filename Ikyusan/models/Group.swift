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

enum GroupType {
    case Join       // 参加済み
    case Invited    // 招待されているところ
}

class Group: Mappable {
    
    /*
    #  id             :integer          not null, primary key
    #  name           :string(255)
    #  membar_max_num :integer
    #  topic_max_num  :integer
    #  created_at     :datetime         not null
    #  updated_at     :datetime         not null
    */
    
    var identifier      = Dynamic<Int>(0)
    var name            = Dynamic<String>("")
    var membarMaxNum    = Dynamic<Int>(0)
    var topicMaxNum     = Dynamic<Int>(0)
    var createdAt       = Dynamic<String>("")
    var updatedAt       = Dynamic<String>("")
    var colorCodeId     = Dynamic<Int>(0)
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init() {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        name.value            <- map["name"]
        membarMaxNum.value    <- map["membar_max_num"]
        topicMaxNum.value     <- map["topic_max_num"]
//        color                 = Color(map["color"])!
//        color                 = Mapper<Color>().map(map["color"])!
        colorCodeId.value     <- map["color.color_code_id"]
        print("color : " + String(topicMaxNum.value) +  "\n")
        print("color : " + String(colorCodeId.value))
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
