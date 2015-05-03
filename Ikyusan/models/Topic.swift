//
//  Topic.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

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
    
    var identifier      : Int?
    var groupId         : Int?
    var builderId       : Int?
    var name            : String?
    var ideaMaxNum      : Int?
    var createdAt       : String?
    var updatedAt       : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        groupId         <- map["group_id"]
        builderId       <- map["builder_id"]
        name            <- map["name"]
        ideaMaxNum      <- map["idea_max_num"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
    
}
