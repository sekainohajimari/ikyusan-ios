//
//  User.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import ObjectMapper

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
    
    var identifier  : Int?
    var provider    : String?
    var uid         : String?
    var screenName  : String?
    var screenUrl   : String?
    var status      : Int?
    var createdAt   : String?
    var updatedAt   : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        identifier      <- map["id"]
        provider        <- map["provider"]
        uid             <- map["uid"]
        screenName      <- map["screen_name"]
        screenUrl       <- map["screen_url"]
        status          <- map["status"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}
