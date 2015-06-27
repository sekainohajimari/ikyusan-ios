//
//  GroupListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import SWTableViewCell
import BlocksKit
import ObjectMapper

class GroupListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    GroupCreateViewControllerDelegate,
    SWTableViewCellDelegate {

    @IBOutlet weak var groupTableView: UITableView!
    
    var list = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.removeSeparatorsWhenUsingDefaultCell()
        
        self.navigationItem.title = kNavigationTitleGroupList
        
        self.setBackButton()
        
        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.groupTableView.addSubview(refresh)
        
        let settingButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Organize,
            handler:{ (t) -> Void in
                var vc = AccountEditViewController()
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = settingButton
        
        let notificationButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Bookmarks,
            handler:{ (t) -> Void in
                var vc = NotificationListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                var vc = GroupCreateViewController()
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItems = [addButton, notificationButton]
        
        self.requestGroups(nil)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "edit")
        return buttons
    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.requestGroups { () -> Void in
            sender.endRefreshing()
//            self.groupTableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func requestGroups(block :(() -> Void)?) {
//        showLoading()
        
        ApiHelper.sharedInstance.call(ApiHelper.GroupList()) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list = box.value
                self.groupTableView.reloadData()
            case .Failure(let box):
                println(box.value) // NSError
            }
            if let b = block {
                b()
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
        if let groupId = self.list[indexPath.row].identifier {
            var vc = TopicListViewController(groupId: groupId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            var vc = GroupEditViewController(group: self.list[index])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - XXXXX

    func groupCreateViewControllerUpdated() {
        self.navigationController?.popViewControllerAnimated(true)
        self.requestGroups { () -> Void in
            ToastHelper.make(self.view, message: "グループを作成しました")
        }
    }

}
