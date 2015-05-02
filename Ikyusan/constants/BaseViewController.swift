//
//  BaseViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

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
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
    }
    
    func setEndEditWhenViewTapped() {
        var tap:UITapGestureRecognizer = UITapGestureRecognizer()
        tap.addTarget(self, action: "_viewTapped:") //TODO:closureで書きたい
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func _viewTapped(sender:AnyObject) {
        self.view.endEditing(true)
    }

}
