//
//  Colors.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

let kBackgroundColor        = Colors.getUIColorFromRGBValue(243.0, 253.0, 248.0)
let kBaseNabigationColor    = UIColor.whiteColor()

enum GroupColor :Int {
    case Black      = 1
    case White      = 2
    case Blue       = 3
    case Yellow     = 4
    case Red        = 5
    case Gray       = 6
    case Purple     = 7

    func getColor() -> UIColor {
        switch self {
            case .Black     : return UIColor.blackColor()
            case .White     : return UIColor.whiteColor()
            case .Blue      : return UIColor.blueColor()
            case .Yellow    : return UIColor.yellowColor()
            case .Red       : return UIColor.redColor()
            case .Gray      : return UIColor.darkGrayColor()
            case .Purple    : return UIColor.purpleColor()
            default         : return UIColor.purpleColor() //temp
        }
    }

    func getStringColor() -> UIColor {
        switch self {
        case .Black     : return UIColor.whiteColor()
        case .White     : return UIColor.blackColor()
        case .Blue      : return UIColor.whiteColor()
        case .Yellow    : return UIColor.blackColor()
        case .Red       : return UIColor.whiteColor()
        case .Gray      : return UIColor.whiteColor()
        case .Purple    : return UIColor.whiteColor()
        default         : return UIColor.blackColor() //temp
        }
    }
}

class Colors {

    class func getUIColorFromRGBValue(r :CGFloat, _ g :CGFloat, _ b :CGFloat, _ a :CGFloat = 1.0) -> UIColor {
        return UIColor(
            red:   r/255.0,
            green: g/255.0,
            blue:  b/255.0,
            alpha: a)
    }
   
}
