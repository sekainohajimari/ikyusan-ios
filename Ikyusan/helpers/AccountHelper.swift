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
        return ""
        return "Token token=\"c9ccf7b8ecd186792829f0e1d54c67741feb7f467a39902cc158ef83e9e458423166804258971f13\""
    }
    
    func setAccessToken(token :String) {
        
    }
    
}
