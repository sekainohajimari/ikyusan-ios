//
//  GroupCreateViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

protocol GroupCreateViewControllerDelegate {
    func groupCreateViewControllerUpdated()
}

class GroupCreateViewController: BaseViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!

    @IBOutlet weak var colorListScrollView: UIScrollView!
    

    var delegate :GroupCreateViewControllerDelegate?
    
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

        self.setCloseButton(nil)

        var groupColorListView = GroupColorListView.loadFromNib() as? GroupColorListView
        groupColorListView?.setupColors()
        self.colorListScrollView.addSubview(groupColorListView!)
        self.colorListScrollView.contentSize.width = 512 // temp
        
        let doneButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Done,
            handler:{ (t) -> Void in
                if !self.validate() {
                    showError(message: "グループ名は1文字以上20文字以内です")
                    return
                }

                showLoading()
                var params = ["name" : self.groupNameTextField.text!]
                ApiHelper.sharedInstance.call(ApiHelper.CreateGroup(params: params)) { response in
                    switch response {
                    case .Success(let box):
                        hideLoading()
                        println(box.value)
                        self.delegate!.groupCreateViewControllerUpdated()
                    case .Failure(let box):
                        hideLoading()
                        println(box.value) // NSError
                    }
                }
                
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
