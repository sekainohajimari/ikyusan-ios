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
import ObjectMapper

class TopicListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    SWTableViewCellDelegate {
    
    @IBOutlet weak var topicTableView: UITableView!
    
    var groupId :Int
    
    var list = [Topic]()
    
    init(groupId :Int) {
        self.groupId = groupId
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
                var vc = TopicEditViewController(groupId :self.groupId, topicName: "")
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = addButton
        
        requestTopics(self.groupId)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "edit")
        return buttons
    }
    
    func requestTopics(groupId :Int) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.TopicList(groupId: groupId)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list = box.value
                self.topicTableView.reloadData()
                hideLoading()
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.delegate = self
        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
        cell.textLabel?.text = list[indexPath.row].name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let topicId = self.list[indexPath.row].identifier {
            var vc = IdeaListViewController(groupId: groupId, topicId: topicId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            var vc = TopicEditViewController(groupId :groupId, topicName: cell.textLabel!.text!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
