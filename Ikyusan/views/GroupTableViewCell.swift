//
//  GroupTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/25.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.colorView.setCornerRadius(self.colorView.getWidth() / 2)
    }
    
}
