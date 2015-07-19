//
//  AccountEditViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import BlocksKit
import Bond

class AccountEditViewController: BaseViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profile = Profile()
    
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
                showLoading()
                ApiHelper.sharedInstance.call(ApiHelper.ProfileEdit(displayId: self.profile.displayId.value,
                    name: self.profile.displayName.value)) { response in
                    switch response {
                    case .Success(let box):
                        println(box.value)
                        self.profile = box.value
                        self.setupBond()
                        hideLoading()
                        self.navigationController?.popViewControllerAnimated(true)
                    case .Failure(let box):
                        println(box.value) // NSError
                        hideLoading()
                    }
                }
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.requestProfile()
    }
    
    func setupBond() {
        self.profile.displayName <->> self.nameLabel.dynText

        // TODO: refactor
        self.profile.iconUrl.map { (str :String) -> UIImage in
            var url = NSURL(string: str)
            if let existUrl = url {
                var data = NSData(contentsOfURL: existUrl)
                if let existData = data {
                    return UIImage(data: existData)!
                } else {
                    return UIImage()
                }
            } else {
                return UIImage()
            }
        } ->> self.profileImageView.dynImage
    }
    
    func requestProfile() {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.ProfileInfo()) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.profile = box.value
                self.setupBond()
                hideLoading()
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
            }
        }
    }
    

    // MARK: - IB action
    
    @IBAction func profileImageButtonTapped(sender: AnyObject) {
        var alert = UIAlertController(title: nil,
            message: kMessageRemoveAvatar,
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
