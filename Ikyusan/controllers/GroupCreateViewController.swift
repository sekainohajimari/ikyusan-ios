//
//  GroupCreateViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class GroupCreateViewController: BaseViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    init() {
        super.init(nibName: "GroupCreateViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup() {
        
        self.navigationItem.title = kNavigationTitleGroupCreate
        
        self.view.backgroundColor = kBackgroundColor
        
        self.setEndEditWhenViewTapped()
        
        let doneButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Done,
            handler:{ (t) -> Void in
                if !self.validate() {
                    showError(message: "グループ名は1文字以上20文字以内です")
                    return
                }
                self.navigationController?.popViewControllerAnimated(true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func validate() -> Bool {
        
        //spaceのみかどうかのチェックを入れる？
        
        if count(groupNameTextField.text) == 0 ||
            count(groupNameTextField.text) > 20 {
            return false
        }
        
        return true
    }

}
