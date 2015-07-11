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
import Bond

class GroupListViewController: BaseViewController,
    UITableViewDelegate,
    GroupCreateViewControllerDelegate,
    SWTableViewCellDelegate {

    @IBOutlet weak var groupTableView: UITableView!
    
    var list = DynamicArray<Group>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<SWTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.groupTableView.delegate = self
//        groupTableView.dataSource = self
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.groupTableView)
        self.groupTableView.removeSeparatorsWhenUsingDefaultCell()

        //---------------
        self.list.map { [unowned self] (group: Group) -> SWTableViewCell in
            let cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.delegate = self
            cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
            group.name ->> cell.textLabel!.dynText
            return cell
        } ->> self.tableViewDataSourceBond
        //---------------
        
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
        self.navigationItem.rightBarButtonItems = [notificationButton]
        
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
                self.list.value = box.value
                self.groupTableView.reloadData()
            case .Failure(let box):
                println(box.value) // NSError
            }
            if let b = block {
                b()
            }
        }
    }

    // MARK: - IB action

    @IBAction func addButtonTapped(sender: AnyObject) {
        var vc = GroupCreateViewController()
        vc.delegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }


    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section name test" + String(section)
    }

    // テーブルビューのヘッダの色を変える
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.greenColor()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
//        var cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//        cell.delegate = self
//        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
//        cell.textLabel?.text = list[indexPath.row].name
//        
//        return cell
//    }


    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let groupId = self.list[indexPath.row].identifier.value {
//            var vc = TopicListViewController(groupId: groupId)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        let groupId = self.list[indexPath.row].identifier.value
        var vc = TopicListViewController(groupId: groupId)
        self.navigationController?.pushViewController(vc, animated: true)
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
