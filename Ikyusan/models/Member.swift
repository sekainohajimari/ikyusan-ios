//
//  Member.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

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
    
    var identifier  : Int?
    var groupId     : Int?
    var userId      : Int?
    var role        : Int?
    var status      : Int?
    var createdAt   : String?
    var updatedAt   : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        groupId         <- map["group_id"]
        userId          <- map["user_id"]
        role            <- map["role"]
        status          <- map["status"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}
