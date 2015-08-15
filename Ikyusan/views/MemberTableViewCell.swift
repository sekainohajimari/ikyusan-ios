//
//  MemberTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/08/15.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.text  = ""
        subLabel.text   = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
