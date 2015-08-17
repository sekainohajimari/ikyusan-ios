//
//  InviteViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/07/25.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Bond

class InviteViewController: BaseViewController {

    var groupId = 0

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(groupId :Int) {
        super.init(nibName: "InviteViewController", bundle: nil)
        self.groupId = groupId
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
        self.navigationItem.title = kNavigationDoInvite

        setEndEditWhenViewTapped()

        map(self.idTextField.dynText) { text in
            return count(text) > 0
        } ->> self.inviteButton.dynEnabled

    }

    @IBAction func inviteButtonTapped(sender: AnyObject) {
        if self.idTextField.text.isEmpty {
            return
        }
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.InviteGroup(groupId: self.groupId, targetDisplayId: self.idTextField.text)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                hideLoading()
                ToastHelper.make(self.view, message: "招待しました!!")
                self.idTextField.text = ""
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
                ToastHelper.make(self.view, message: "存在しないIDです")
            }
        }
    }


}
