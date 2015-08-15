//
//  GroupTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/25.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Bond

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.colorView.setCornerRadius(radius: self.colorView.getWidth() / 2)

//        lazy var editTapListener = Bond<UIControlEvents>() { event in
//            print("iniesta!")
//        }
//        self.editButton.dynEvent.filter(==, .TouchUpInside) ->> editTapListener
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
