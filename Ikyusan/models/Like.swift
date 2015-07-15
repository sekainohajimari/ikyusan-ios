//
//  Like.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Like: Mappable {
   /*
    #  id         :integer          not null, primary key
    #  idea_id    :integer
    #  liker_id   :integer
    #  num        :integer
    #  created_at :datetime         not null
    #  updated_at :datetime         not null
*/
    
    var identifier  = Dynamic<Int>(0)
    var idea        = Idea()
    var likeUser    = User()
    var num         = Dynamic<Int>(0)
    var createdAt   = Dynamic<String>("")
    var updatedAt   = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }

    init () {
        //
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        idea                  = Idea(map["idea"])!
        likeUser              = User(map["like_user"])!
        num.value             <- map["num"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
