//
//  IdeaTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit;
import TTTAttributedLabel
import Bond

protocol IdeaTableViewCellDelegate {
    func ideaTableViewCellLikeButtonTapped(ideaId :Int)
    func ideaTableViewCellLikeMaxCount()
    func ideaTableViewCellLongPressed(ideaId :Int)
}

class IdeaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!

    @IBOutlet weak var likeCountLabel: UILabel!

    var likeAnimationColor = UIColor.whiteColor() // Dynamic<UIColor>(UIColor.whiteColor())

    // ここ、ideaモデル自体をバインディングしたいけど・・・
    var identifier  = Dynamic<Int>(0)
    var likeCount   = Dynamic<Int>(0)

    var ideaTableViewCellDelegate :IdeaTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupGesture()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupGesture() {
        let tap: AnyObject! = UILongPressGestureRecognizer().bk_initWithHandler { (gesture, state, point) -> Void in
            self.ideaTableViewCellDelegate?.ideaTableViewCellLongPressed(self.identifier.value)
        }
        self.addGestureRecognizer(tap as! UILongPressGestureRecognizer)
    }

    @IBAction func likeButtonTapped(sender: AnyObject) {
        // TODO: スキの最大はあくまで１人が100かな？？
        if self.likeCount.value >= kValuesLikeMaxCount {
            self.ideaTableViewCellDelegate?.ideaTableViewCellLikeMaxCount()
            return
        }
        
        self.likeCount.value++

        // animation
        self.backgroundColor = UIColor.whiteColor()
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.backgroundColor = self.likeAnimationColor
        }) { (Bool) -> Void in
            self.backgroundColor = UIColor.whiteColor()
        }

        self.ideaTableViewCellDelegate?.ideaTableViewCellLikeButtonTapped(self.identifier.value)
    }
    
    class func getCellHeight(idea :Idea, parentWidth :CGFloat) -> CGFloat {
        var label = TTTAttributedLabel(frame: CGRectZero)
        label.numberOfLines = 0
        label.font = UIFont(name: "HiraKakuProN-W3", size: 14)
        label.setWidth(parentWidth - 60 - 60)
        label.text = idea.content.value
        label.sizeToFit()
        return 55 + label.getHeight() + kValuesAdjustmentForDecenderCharacter + 14 // topmargin, gypq対応, bottommargin
    }
    
}
