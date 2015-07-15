//
//  User.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper
import Bond

class User: Mappable {
   
    /*
    #  id          :integer          not null, primary key
    #  provider    :string(255)
    #  uid         :string(255)
    #  screen_name :string(255)
    #  screen_url  :string(255)
    #  status      :integer
    #  created_at  :datetime         not null
    #  updated_at  :datetime         not null
*/
    
    var identifier  = Dynamic<Int>(0)
    var provider    = Dynamic<String>("")
    var uid         = Dynamic<String>("")
    var screenName  = Dynamic<String>("")
    var screenUrl   = Dynamic<String>("")
    var status      = Dynamic<Int>(0)
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
        provider.value        <- map["provider"]
        uid.value             <- map["uid"]
        screenName.value      <- map["screen_name"]
        screenUrl.value       <- map["screen_url"]
        status.value          <- map["status"]
        createdAt.value       <- map["created_at"]
        updatedAt.value       <- map["updated_at"]
    }
}
