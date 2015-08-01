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
import Bond

protocol IdeaTableViewCellDelegate {
    func ideaTableViewCellLikeButtonTapped(ideaId :Int)
    func ideaTableViewCellLikeMaxCount()
}

class IdeaTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!

    @IBOutlet weak var likeCountLabel: UILabel!

    // ここ、ideaモデル自体をバインディングしたいけど・・・
    var identifier  = Dynamic<Int>(0)
    var likeCount   = Dynamic<Int>(0)

    var ideaTableViewCellDelegate :IdeaTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonTapped(sender: AnyObject) {
        // TODO: スキの最大はあくまで１人が100かな？？
        if self.likeCount.value >= kValuesLikeMaxCount {
            self.ideaTableViewCellDelegate?.ideaTableViewCellLikeMaxCount()
            return
        }
        
        self.likeCount.value++
//        likeCountLabel.text = String(data!.likeCount)

//        LikeHelper.animationStart(likeCountLabel)

        self.ideaTableViewCellDelegate?.ideaTableViewCellLikeButtonTapped(self.identifier.value)
    }
    
    class func getCellHeight(idea :Idea, parentWidth :CGFloat) -> CGFloat {
        // memo:bad way??
        var label = TTTAttributedLabel(frame: CGRectZero) //temp
        label.numberOfLines = 0
        label.font = UIFont(name: "HiraKakuProN-W3", size: 14)
        label.setWidth(parentWidth - 8 - 8)
        label.text = idea.content.value
        label.sizeToFit()
        NSLog("%f", label.getHeight())
        return 39 + label.getHeight() + 40 //temp
    }
    
}
