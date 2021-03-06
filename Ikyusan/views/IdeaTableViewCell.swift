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
    func ideaTableViewCellLongPressed(ideaId :Int, body :String)
}

class IdeaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView  : UIImageView!
    @IBOutlet weak var posterLabel      : UILabel!
    @IBOutlet weak var dateLabel        : UILabel!
    @IBOutlet weak var contentLabel     : TTTAttributedLabel!
    @IBOutlet weak var likeCountLabel   : UILabel!

    var likeAnimationColor = UIColor.whiteColor() // Dynamic<UIColor>(UIColor.whiteColor())

    // ここ、ideaモデル自体をバインディングしたいけど・・・
    var identifier  = Dynamic<Int>(0)
    var likeCount   = Dynamic<Int>(0)

    var ideaTableViewCellDelegate :IdeaTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupGesture()
    }

    private func setupGesture() {
        let tap: AnyObject! = UILongPressGestureRecognizer().bk_initWithHandler { (gesture, state, point) -> Void in
            let ideaId = self.identifier.value
            let body = self.contentLabel.text
            self.ideaTableViewCellDelegate?.ideaTableViewCellLongPressed(ideaId, body: body!)
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

        // animation ダサい書き方だけど・・・
        self.backgroundColor = UIColor.whiteColor()
        UIView.animateWithDuration(0.18, animations: { () -> Void in
            self.backgroundColor = self.likeAnimationColor
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.18, animations: { () -> Void in
                self.backgroundColor = UIColor.whiteColor()
                }) { (Bool) -> Void in
                    return
            }
        }

        self.ideaTableViewCellDelegate?.ideaTableViewCellLikeButtonTapped(self.identifier.value)
    }
    
    class func getCellHeight(idea :Idea, parentWidth :CGFloat) -> CGFloat {
        var label = TTTAttributedLabel(frame: CGRectZero)
        label.numberOfLines = 0
        label.font = UIFont(name: kBaseFontName, size: 14)
        label.setWidth(parentWidth - 60 - 60)
        label.text = idea.content.value
        label.sizeToFit()
        return 55 + label.getHeight() + kValuesAdjustmentForDecenderCharacter + 14 // topmargin, gypq対応, bottommargin
    }
    
}
