//
//  Idea.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

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
    
    var identifier  : Int?
    var topicId     : Int?
    var posterId    : Int?
    var content     : String?
    var anonymity   : Int?
    var createdAt   : String?
    var updatedAt   : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        topicId         <- map["topic_id"]
        posterId        <- map["poster_id"]
        content         <- map["content"]
        anonymity       <- map["anonymity"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}
