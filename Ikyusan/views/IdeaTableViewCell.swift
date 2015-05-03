//
//  IdeaTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit;
import SWTableViewCell
import TTTAttributedLabel

protocol IdeaTableViewCellDelegate {
    func ideaTableViewCellLikeButtonTapped()
}

class IdeaTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var contentLabel: TTTAttributedLabel!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var ideaTableViewCellDelegate :IdeaTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(idea :Idea) {
        contentLabel.text = idea.content
        contentLabel.sizeToFit()
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        self.ideaTableViewCellDelegate?.ideaTableViewCellLikeButtonTapped()
    }
    
    class func getCellHeight(idea :Idea, parentWidth :CGFloat) -> CGFloat {
        // memo:bad way??
        var label = TTTAttributedLabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HiraKakuProN-W3", size: 14)
        label.setWidth(parentWidth - 8 - 8)
        label.text = idea.content
        label.sizeToFit()
        NSLog("%f", label.getHeight())
        return 8 + label.getHeight() + 44
    }
    
}
