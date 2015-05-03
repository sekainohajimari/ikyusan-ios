//
//  TopicListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import SWTableViewCell
import BlocksKit
import Toast

class TopicListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    SWTableViewCellDelegate {
    
    @IBOutlet weak var topicTableView: UITableView!
    
    var list = [
        "セカハマfm ネタ帳",
        "食レポ",
        "ゲスト候補一覧",
    ]
    
    init(groupId :Int) {
        super.init(nibName: "TopicListViewController", bundle: nil)
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
        topicTableView.delegate = self
        topicTableView.dataSource = self
        topicTableView.removeSeparatorsWhenUsingDefaultCell()
        
        self.navigationItem.title = kNavigationTitleTopicList
        
        self.setBackButton()
        
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                //
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "edit")
        return buttons
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.delegate = self
        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = IdeaListViewController(topicId: 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            self.view.makeToast("edit!!")
        }
    }

}
