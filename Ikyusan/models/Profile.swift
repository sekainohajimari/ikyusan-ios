//
//  Profile.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

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
    
    var identifier      = Dynamic<Int>(0)
    var userId          = Dynamic<Int>(0)
    var displayId       = Dynamic<String>("")
    var displayName     = Dynamic<String>("")
//    var affiliation     : String?
//    var place           : String?
//    var website         : String?
//    var introduction    : String?
    var createdAt       = Dynamic<String>("")
    var updatedAt       = Dynamic<String>("")
    var iconUrl         = Dynamic<String>("")
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier.value      <- map["id"]
        userId.value          <- map["user_id"]
        displayId.value       <- map["display_id"]
        displayName.value     <- map["display_name"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
        iconUrl.value         <- map["icon_url"]
    }
}
