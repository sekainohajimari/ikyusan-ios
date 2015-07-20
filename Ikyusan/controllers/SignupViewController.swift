//
//  SingupViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/06/13.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func twitterSignupButtonTapped(sender: AnyObject) {
        var vc = TwitterAuthViewController(nibName: "TwitterAuthViewController", bundle: nil)
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
}
