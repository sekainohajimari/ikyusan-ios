//
//  AccountHelper.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class AccountHelper: NSObject {
   
    //singleton
    class var sharedInstance : AccountHelper {
        struct Static {
            static let instance : AccountHelper = AccountHelper()
        }
        return Static.instance
    }
    
//    override init() {
//        super.init()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    func getAccessToken() -> String {
        return ""
    }
    
    func setAccessToken(token :String) {
        
    }
    
}
