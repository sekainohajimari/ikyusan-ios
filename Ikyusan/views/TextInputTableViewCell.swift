//
//  TextInputTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class TextInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPlaceholder(text :String) {
        self.textField.placeholder = text
    }
    
    func getText() -> String {
        return self.textField.text
    }
    
}