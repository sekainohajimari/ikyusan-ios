
//
//  StringExtension.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

extension String {
    
    func getDate() -> NSDate {
        var df :NSDateFormatter = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "ja")
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df.dateFromString(self)!
    }
    
    func trimSpaceCharacter() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func urlEncode() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
}