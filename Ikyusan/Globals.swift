//
//  Globals.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import SVProgressHUD

class Globals: NSObject {
   
}

func showLoading() {
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
}

func hideLoading() {
    dispatch_async_main {
        SVProgressHUD.dismiss()
    }
}

func dispatch_async_main(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func dispatch_async_global(block: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}
