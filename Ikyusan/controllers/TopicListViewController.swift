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
import Bond

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
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor() // Groupから取得するようにする
        
        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.topicTableView.addSubview(refresh)
        
        self.setBackButton()
        
//        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
//            handler:{ (t) -> Void in
//                var vc = TopicEditViewController(groupId :self.groupId, topicId :nil, topicName: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
//                
//        }) as! UIBarButtonItem
//        self.navigationItem.rightBarButtonItem = addButton

        requestTopics(self.groupId, block: nil)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "edit")
        return buttons
    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.requestTopics(self.groupId) { () -> Void in
            sender.endRefreshing()
            //            self.groupTableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func requestTopics(groupId :Int, block :(() -> Void)?) {
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
            if let b = block {
                b()
            }
        }
    }

    // MARK: - IB action

    @IBAction func createButtonTapped(sender: AnyObject) {
        var vc = TopicEditViewController(groupId :self.groupId, topicId :nil, topicName: nil)
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = TopicTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.delegate = self
        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
        cell.setData(list[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = IdeaListViewController(groupId: groupId, topicId: self.list[indexPath.row].identifier.value)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            if let topic = (cell as! TopicTableViewCell).topic {
                var vc = TopicEditViewController(groupId: self.groupId, topicId: topic.identifier.value, topicName: topic.name.value)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
