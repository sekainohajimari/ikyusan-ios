//
//  NotificationTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/09.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationLabel: TTTAttributedLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setData(notification :Notification) {
//        //
//    }
    
//    class func getCellHeight(notification :Notification, parentWidth :CGFloat) -> CGFloat {
        // memo:bad way??
//        var label = TTTAttributedLabel()
//        label.numberOfLines = 0
//        label.font = UIFont(name: "HiraKakuProN-W3", size: 14)
//        label.setWidth(parentWidth - 8 - 8)
//        label.text = idea.content
//        label.sizeToFit()
//        NSLog("%f", label.getHeight())
//        return 8 + label.getHeight() + 44
//    }
}
