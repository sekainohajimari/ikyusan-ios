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
    TopicCreateViewControllerDelegate {
    
    @IBOutlet weak var topicTableView: UITableView!
    @IBOutlet weak var postButton: UIButton!

    var group :Group
    var list = [Topic]()

    init(group :Group) {
        self.group = group
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

        self.setCloseButton(nil)

        self.group.name ->> self.navigationItem.dynTitle

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        // dynTintColorのようなものがない
//        map(self.group.colorCodeId) { colorId in
//            return GroupColor(rawValue: colorId)!.getColor()
//        } ->> self.navigationController!.navigationBar.dynBackgroundColor

        self.navigationController?.navigationBar.barTintColor = GroupColor(rawValue: self.group.colorCodeId.value)?.getColor()
        self.navigationController?.navigationBar.alpha = 1.0
        
        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.topicTableView.addSubview(refresh)
        
        self.setBackButton()
        
        let editButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Edit,
            handler:{ (t) -> Void in
                var vc = GroupEditViewController(groupId: self.group.identifier.value)
                self.navigationController?.pushViewController(vc, animated: true)
                
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = editButton

        self.postButton.setTitleColor(GroupColor(rawValue: self.group.colorCodeId.value)?.getColor(), forState: UIControlState.Normal)

        requestTopics(self.group.identifier.value, block: nil)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "edit")
        return buttons
    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.requestTopics(self.group.identifier.value) { () -> Void in
            sender.endRefreshing()
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
        var vc = TopicEditViewController(groupId :self.group.identifier.value, colorCodeId :self.group.colorCodeId.value, topicId :nil, topicName: nil)
        vc.delegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = TopicTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.setData(list[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = IdeaListViewController(groupId: self.group.identifier.value,
            topicId: self.list[indexPath.row].identifier.value,
            colorCodeId: self.group.colorCodeId.value)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            if let topic = (cell as! TopicTableViewCell).topic {
                var vc = TopicEditViewController(groupId: self.group.identifier.value, colorCodeId: self.group.colorCodeId.value, topicId: topic.identifier.value, topicName: topic.name.value)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    // MARK: - TopicCreateViewControllerDelegate

    func topicCreateViewControllerUpdated() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.requestTopics(self.group.identifier.value, block: { () -> Void in
                ToastHelper.make(self.view, message: "トピックを作成しました")
            })
        })
    }

}
