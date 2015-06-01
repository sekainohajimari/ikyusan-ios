//
//  TopicEditViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

/** 
    memo:
    編集も新規作成も併用
    initのtopicnameで判定する
*/
class TopicEditViewController: BaseViewController {
    
    @IBOutlet weak var topicNameTextField: UITextField!
    
    var groupId :Int
    
    var initialTopicName :String?
    
    init(groupId :Int, topicName :String?) {
        self.groupId = groupId
        self.initialTopicName = topicName
        super.init(nibName: "TopicEditViewController", bundle: nil)
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
        
        self.navigationItem.title = self.getTitle()
        
        self.view.backgroundColor = kBackgroundColor
        
        self.setEndEditWhenViewTapped()
        
        if let topicName = self.initialTopicName {
            self.topicNameTextField.text = topicName
        }
        
        let doneButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Done,
            handler:{ (t) -> Void in
                if !self.validate() {
                    showError(message: "トピック名は1文字以上20文字以内です")
                    return
                }
                ApiHelper.sharedInstance.call(ApiHelper.CreateTopic(groupId: self.groupId, name: self.topicNameTextField.text)) { response in
                    switch response {
                    case .Success(let box):
                        println(box.value)
                        hideLoading()
                        self.navigationController?.popViewControllerAnimated(true)
                    case .Failure(let box):
                        println(box.value) // NSError
                        hideLoading()
                    }
                }
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getTitle() -> String {
        if self.initialTopicName?.isEmpty == true {
            return kNavigationTitleTopicCreate
        } else {
            return kNavigationTitleTopicEdit
        }
    }
    
    private func validate() -> Bool {
        
        //spaceのみかどうかのチェックを入れる？
        
        if count(topicNameTextField.text) == 0 ||
            count(topicNameTextField.text) > 20 {
                return false
        }
        
        return true
    }

}
