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
    
    func getUserId() -> Int {
        return 2
    }
    
    func setUserId(token :Int) {
        
    }
    
    func getAccessToken() -> String {
        return "Token token=\"d6ad5c61da3e28b3302c44c082ef878abe195c27269f2b04f4723625950f5b1d2cb3020dd8df740a\""
    }
    
    func setAccessToken(token :String) {
        
    }
    
}
