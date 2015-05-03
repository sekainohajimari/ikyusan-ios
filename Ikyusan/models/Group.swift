//
//  Group.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

class Group: Mappable {
    
    /*
    #  id             :integer          not null, primary key
    #  name           :string(255)
    #  membar_max_num :integer
    #  topic_max_num  :integer
    #  created_at     :datetime         not null
    #  updated_at     :datetime         not null
    */
    
    var identifier      : Int?
    var name            : String?
    var membarMaxNum    : Int?
    var topicMaxNum     : Int?
    var createdAt       : String?
    var updatedAt       : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        name            <- map["id"]
        membarMaxNum    <- map["id"]
        topicMaxNum     <- map["id"]
        createdAt       <- map["id"]
        updatedAt       <- map["id"]
    }
}
