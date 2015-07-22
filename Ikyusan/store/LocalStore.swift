//
//  LocalStore.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/20.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Realm

class LocalStore: RLMObject {
    dynamic var serialId            = 0
    dynamic var identifier          = 0
    dynamic var token               = ""
    dynamic var displayId           = ""
    dynamic var displayName         = ""
    dynamic var iconUrl             = ""
    dynamic var inUseDefaultIcon    = ""

    // primaryKeyの指定.
    override class func primaryKey() -> String {
        return "serialId"
    }
}
