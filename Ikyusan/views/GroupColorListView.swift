//
//  GroupColorListView.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/10.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

// temp 多分別のしかるべき場所に定義する
enum GroupColor {

}

class GroupColorListView: UIView {

    class func loadFromNib() -> AnyObject {
        var nib = UINib(nibName: "GroupColorListView", bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil)[0]
    }

    // TODO: initializeと同時に呼べない？？
    func setupColors() {
        for v in self.subviews {
            (v as! UIView).backgroundColor = UIColor.blackColor()
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        print(sender.tag)
    }
}
