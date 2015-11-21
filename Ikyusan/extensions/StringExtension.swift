
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

    func toMD5() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }

        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }

        return digestHex
    }
    
}