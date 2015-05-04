//
//  InviteTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class InviteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func inviteButtonTapped(sender: AnyObject) {
        accountTextField.resignFirstResponder() // TODO:動く？？
        if !self.validate() {
            showError()
            return
        }
        accountTextField.text = ""
        
        //delegateで親に投げる？？
    }
    
    private func validate() -> Bool {
        return true
    }
    
}
