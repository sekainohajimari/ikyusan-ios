//
//  UIBarButtonItemExtension.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/09.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(badgeText: String, color: UIColor = UIColor.redColor(), fontSize: CGFloat = UIFont.smallSystemFontSize()) {
        self.init()
        text = " \(badgeText) "
        textColor = UIColor.whiteColor()
        backgroundColor = color
        
        font = UIFont.systemFontOfSize(fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
    }
}

extension UIButton {
    /// show background as rounded rect, like mail addressees
    var rounded: Bool {
        get { return layer.cornerRadius > 0 }
        set { roundWithTitleSize(newValue ? titleSize : 0) }
    }
    
    /// removes other title attributes
    var titleSize: CGFloat {
        get {
            let titleFont = attributedTitleForState(.Normal)?.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
            return titleFont?.pointSize ?? UIFont.buttonFontSize()
        }
        set {
            // TODO: use current attributedTitleForState(.Normal) if defined
            if UIFont.buttonFontSize() == newValue || 0 == newValue {
                setTitle(currentTitle, forState: .Normal)
            }
            else {
                let attrTitle = NSAttributedString(string: currentTitle ?? "", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(newValue)])
                setAttributedTitle(attrTitle, forState: .Normal)
            }
            
            if rounded {
                roundWithTitleSize(newValue)
            }
        }
    }
    
    func roundWithTitleSize(size: CGFloat) {
        let padding = size / 4
        layer.cornerRadius = padding + size * 1.2 / 2
        let sidePadding = padding * 1.5
        contentEdgeInsets = UIEdgeInsets(top: padding, left: sidePadding, bottom: padding, right: sidePadding)
        
        if size.isZero {
            backgroundColor = UIColor.clearColor()
            setTitleColor(tintColor, forState: .Normal)
        }
        else {
            backgroundColor = tintColor
            let currentTitleColor = titleColorForState(.Normal)
            if currentTitleColor == nil || currentTitleColor == tintColor {
                setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
        }
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        if rounded {
            backgroundColor = tintColor
        }
    }
}

extension UIBarButtonItem {
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector) {
        let button = UIButton.buttonWithType(.System) as! UIButton
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(UIFont.buttonFontSize())
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.sizeToFit()
        
        let badgeLabel = UILabel(badgeText: badge ?? "")
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .Top, relatedBy: .Equal, toItem: button, attribute: .Top, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: button, attribute: .Trailing, multiplier: 1, constant: 0))
        if nil == badge {
            badgeLabel.hidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag
        
        self.init(customView: button)
    }
    
    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }
    
    var badgedButton: UIButton? {
        return customView as? UIButton
    }
    
    var badgeString: String? {
        get { return badgeLabel?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.hidden = nil == newValue
            }
        }
    }
    
    var badgedTitle: String? {
        get { return badgedButton?.titleForState(.Normal) }
        set { badgedButton?.setTitle(newValue, forState: .Normal); badgedButton?.sizeToFit() }
    }
    
    private static let badgeTag = 7373
}
