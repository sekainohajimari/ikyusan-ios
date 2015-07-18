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

class Colors: NSObject {
    
    class func getUIColorFromRGBValue(r :CGFloat, _ g :CGFloat, _ b :CGFloat, _ a :CGFloat = 1.0) -> UIColor {
        return UIColor(
            red:   r/255.0,
            green: g/255.0,
            blue:  b/255.0,
            alpha: a)
    }
   
}
