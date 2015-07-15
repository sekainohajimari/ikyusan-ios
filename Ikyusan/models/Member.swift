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
   
    /*
    #  id         :integer          not null, primary key
    #  group_id   :integer
    #  user_id    :integer
    #  role       :integer
    #  status     :integer
    #  created_at :datetime         not null
    #  updated_at :datetime         not null
*/
    
    var identifier  = Dynamic<Int>(0)
    var groupId     = Dynamic<Int>(0)
    var userId      = Dynamic<Int>(0)
    var role        = Dynamic<Int>(0)
    var status      = Dynamic<Int>(0)
    var createdAt   = Dynamic<String>("")
    var updatedAt   = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        groupId.value         <- map["group_id"]
        userId.value          <- map["user_id"]
        role.value            <- map["role"]
        status.value          <- map["status"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
