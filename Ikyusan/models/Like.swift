//
//  Like.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

class Like: Mappable {
   /*
    #  id         :integer          not null, primary key
    #  idea_id    :integer
    #  liker_id   :integer
    #  num        :integer
    #  created_at :datetime         not null
    #  updated_at :datetime         not null
*/
    
    var identifier  : Int?
    var ideaId      : Int?
    var likerId     : Int?
    var num         : Int?
    var createdAt   : String?
    var updatedAt   : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        ideaId          <- map["idea_id"]
        likerId         <- map["liker_id"]
        num             <- map["num"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}
