//
//  Topic.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Topic: Mappable {
   
    /*
    #  id           :integer          not null, primary key
    #  group_id     :integer
    #  builder_id   :integer
    #  name         :string(255)
    #  idea_max_num :integer
    #  created_at   :datetime         not null
    #  updated_at   :datetime         not null
*/
    
    var identifier      = Dynamic<Int>(0)
    var groupId         = Dynamic<Int>(0)
    var builderId       = Dynamic<Int>(0)
    var name            = Dynamic<String>("")
    var ideaMaxNum      = Dynamic<Int>(0)
    var createdAt       = Dynamic<String>("")
    var updatedAt       = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        groupId.value         <- map["group_id"]
        builderId.value       <- map["builder_id"]
        name.value            <- map["name"]
        ideaMaxNum.value      <- map["idea_max_num"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
    
}
