//
//  Idea.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class Idea: Mappable {
   
    /*
    #  id         :integer          not null, primary key
    #  topic_id   :integer
    #  poster_id  :integer
    #  content    :string(255)
    #  anonymity  :integer
    #  created_at :datetime         not null
    #  updated_at :datetime         not null
*/
    
    var identifier  = Dynamic<Int>(0)
    var topicId     = Dynamic<Int>(0)
    var posterId    = Dynamic<Int>(0)
    var content     = Dynamic<String>("")
    var likeCount   = Dynamic<Int>(0)
    var anonymity   = Dynamic<Int>(0)
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
        topicId.value         <- map["topic_id"]
        posterId.value        <- map["poster_id"]
        content.value         <- map["content"]
        likeCount.value       <- map["likes_count"]
        anonymity.value       <- map["anonymity"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
