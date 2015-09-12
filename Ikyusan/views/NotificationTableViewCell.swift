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

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
