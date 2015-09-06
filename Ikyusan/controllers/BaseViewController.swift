//
//  BaseViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import BlocksKit
import CSNNotificationObserver

class BaseViewController: UIViewController,
    UIGestureRecognizerDelegate {

    var observer = CSNNotificationObserver()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }

    func setCloseButton(completion :(() -> Void)?) {
        let closeButton = UIBarButtonItem().bk_initWithImage(UIImage(named: "icon_close"), style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            self.dismissViewControllerAnimated(true, completion: completion)
        } as! UIBarButtonItem
        self.navigationItem.leftBarButtonItems = [closeButton]
    }
    
    func setEndEditWhenViewTapped() {
        let tap = UITapGestureRecognizer().bk_initWithHandler { (r :UIGestureRecognizer!, s :UIGestureRecognizerState, p :CGPoint) -> Void in
            self.view.endEditing(true)
        } as! UITapGestureRecognizer
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
}
