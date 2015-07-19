//
//  ToastHelper.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/06/27.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class ToastHelper: NSObject {

    class func make(view :UIView, message :String) {
        view.makeToast(message, duration:kValuesToastDuration, position: nil)
    }

    class func make(view :UIView, message :String, duration :Double) {
        view.makeToast(message, duration:duration, position: nil)
    }

}
