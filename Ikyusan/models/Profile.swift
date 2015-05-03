//
//  Profile.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

class Profile: Mappable {
   /*
    #  id           :integer          not null, primary key
    #  user_id      :integer
    #  display_id   :string(255)
    #  display_name :string(255)
    #  affiliation  :string(255)
    #  place        :string(255)
    #  website      :string(255)
    #  introduction :string(255)
    #  created_at   :datetime         not null
    #  updated_at   :datetime         not null
*/
    
    var identifier      : Int?
    var userId          : Int?
    var displayId       : Int?
    var displayName     : String?
//    var affiliation     : String?
//    var place           : String?
//    var website         : String?
//    var introduction    : String?
    var createdAt       : String?
    var updatedAt       : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        userId          <- map["user_id"]
        displayId       <- map["display_id"]
        displayName     <- map["display_name"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}
