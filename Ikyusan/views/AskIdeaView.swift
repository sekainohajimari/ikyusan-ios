//
//  AskIdeaView.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

protocol AskIdeaViewDelegate {
    func askIdeaViewTapped()
}

class AskIdeaView: UIView {
    
    var delegate :AskIdeaViewDelegate?

    class func loadFromNib() -> AnyObject {
        var nib = UINib(nibName: "AskIdeaView", bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil)[0]
    }
    
    @IBAction func wrapButtonTapped(sender: AnyObject) {
        self.delegate?.askIdeaViewTapped()
    }

}
