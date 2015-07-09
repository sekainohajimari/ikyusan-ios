//
//  BaseViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import BlocksKit

class BaseViewController: UIViewController,
    UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setBackButton() {
        var backButton = UIBarButtonItem()
        backButton.title = "back"
        self.navigationItem.backBarButtonItem = backButton
    }

    func setCloseButton(completion :(() -> Void)?) {
        let closeButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Cancel,
            handler:{ (t) -> Void in
            self.dismissViewControllerAnimated(true, completion: completion)
        }) as! UIBarButtonItem

        self.navigationItem.leftBarButtonItems = [closeButton]
    }
    
    func setEndEditWhenViewTapped() {
        var tap = UITapGestureRecognizer().bk_initWithHandler { (r :UIGestureRecognizer!, s :UIGestureRecognizerState, p :CGPoint) -> Void in
            self.view.endEditing(true)
        } as! UITapGestureRecognizer
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
}
