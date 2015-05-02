//
//  AccountEditViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class AccountEditViewController: BaseViewController {
    
    init() {
        super.init(nibName: "AccountEditViewController", bundle: nil)
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
    
    func setup() {
        self.navigationItem.title = kNavigationTitleAccountEdit
        
        self.setEndEditWhenViewTapped()
        
        let saveButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Save,
            handler:{ (t) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = saveButton
    }
    

    // MARK: - IB action
    
    @IBAction func profileImageButtonTapped(sender: AnyObject) {
        var alert = UIAlertController(title: "確認",
            message: "現在プロフィール画像の変更はできません。SNS連携の画像を外してデフォルトの画像にしますか？",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "いいえ",
            style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                //
        }))
        alert.addAction(UIAlertAction(title: "はい",
            style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                //
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
