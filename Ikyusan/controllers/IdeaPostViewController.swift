//
//  IdeaPostViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class IdeaPostViewController: BaseViewController,
    UITextViewDelegate {
    
    @IBOutlet weak var ideaTextView: UITextView!
    
    @IBOutlet weak var ideaTextViewHeightConstraint: NSLayoutConstraint!

    
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
    }
    
    func validate() -> Bool {
        return true
    }
    
    // MARK: - UITableViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.navigationController?.popViewControllerAnimated(true)
            return false
        }
        return true
    }
    
    // MARK: - IB action
    
    @IBAction func askButtonTapped(sender: AnyObject) {
        ideaTextView.text = "スニーカーを左右逆に履いて１日過ごしてみましょう。きっといいアイデアがでますよ"
    }

}
