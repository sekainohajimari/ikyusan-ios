//
//  IdeaPostViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import BlocksKit

class IdeaPostViewController: BaseViewController,
    UITextViewDelegate {
    
    @IBOutlet weak var ideaTextView: UITextView!
    
    @IBOutlet weak var ideaTextViewHeightConstraint: NSLayoutConstraint!
    
    var charCountButton = UIBarButtonItem()

    
    init() {
        super.init(nibName: "IdeaPostViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidLayoutSubviews() {
        ideaTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.view.backgroundColor = kBackgroundColor
        
        self.navigationItem.title = kNavigationTitleIdeaPost
        
        self.automaticallyAdjustsScrollViewInsets = false //uitextfieldのテキストの位置がおかしくなる対応
        
        self.ideaTextView.delegate = self

        charCountButton = UIBarButtonItem().bk_initWithTitle("0/140",
            style: UIBarButtonItemStyle.Plain,
            handler: { (t :AnyObject!) -> Void in
                //
        }) as! UIBarButtonItem
        
        self.navigationItem.rightBarButtonItem = charCountButton
    }
    
    func validate() -> Bool {
        var text = self.ideaTextView.text.trimSpaceCharacter()
        
        if count(text) == 0 {
            return false
        }
        if count(text) > 140 {
            return false
        }
        
        return true
    }
    
    // MARK: - UITableViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        //完了ボタン
        if text == "\n" {
            if self.validate() == false {
                showError(message: "アイデアの投稿は1文字以上140文字以内です")
                return false
            }
            self.navigationController?.popViewControllerAnimated(true)
            return false
        }
        
        let start = advance(textView.text.startIndex, range.location)
        let end = advance(start, range.length)
        let range = Range<String.Index>(start: start, end: end)
        var str = textView.text.stringByReplacingCharactersInRange(range, withString: text)
        charCountButton.title = String(count(str)) + "/140"
        
        return true
    }
    
    // MARK: - IB action
    
    @IBAction func askButtonTapped(sender: AnyObject) {
        ideaTextView.text = "スニーカーを左右逆に履いて１日過ごしてみましょう。きっといいアイデアがでますよ"
    }

}
