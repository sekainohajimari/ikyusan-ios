//
//  TwitterShareViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/10/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Bond

class TwitterShareViewController: BaseViewController {

    @IBOutlet weak var bodyTextField: UITextView!
    @IBOutlet weak var countLabel: UILabel!

    var body = Dynamic<String>("")

    init(body :String = "") {
        self.body.value = body
        super.init(nibName: "TwitterShareViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup() {

        self.setCloseButton(nil)
        //self.setBackButton()

        self.navigationItem.title = "シェアする"

        let shareButton = UIBarButtonItem().bk_initWithTitle("完了", style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            showLoading()
            ApiHelper.sharedInstance.call(ApiHelper.ShareTwitter(body: self.body.value)) { response in
                    switch response {
                    case .Success(let box):
                        pri(box.value)
                        hideLoading()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    case .Failure(let box):
                        pri(box.value) // NSError
                        hideLoading()
                    }
            }
            } as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = shareButton

        map(self.bodyTextField.dynText) { text in
            // TODO: スペースのチェックいれる？
            return count(text) > 0 && count(text) <= 140
            } ->> shareButton.dynEnabled

        map(self.bodyTextField.dynText) { text in
            return String(count(text)) + "/140"
            } ->> self.countLabel.dynText

        map(self.bodyTextField.dynText) { text in
            if count(text) > 140 {
                return UIColor.redColor()
            }
            return kBaseBlackColor
            } ->> self.countLabel.dynTextColor

        self.body <->> self.bodyTextField.dynText
    }

}
