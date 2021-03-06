//
//  TextInputTableViewCell.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

protocol TextInputTableViewCellDelegate {
    func askIdeaViewTapped()
}

class TextInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate :TextInputTableViewCellDelegate?
    
    func setPlaceholder(text :String) {
        self.textField.placeholder = text
    }
    
    func getText() -> String {
        return self.textField.text
    }
}
