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
        
        let settingButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Organize,
            handler:{ (t) -> Void in
                var vc = AccountEditViewController()
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = settingButton
        
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                var vc = GroupCreateViewController()
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = addButton
        
        self.requestGroups()
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "edit")
        return buttons
    }
    
    func requestGroups() {
        showLoading()
        ApiHelper.sharedInstance.getGroups { (result, error) -> Void in
            hideLoading()
            if (error != nil) {
                //
                return
            }
            
            if let groups = result {
                for group in groups {
                    self.list.append(Mapper<Group>().map(group) as Group!)
                }
            }
            self.groupTableView.reloadData()
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
        var vc = TopicListViewController(groupId: 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            var vc = GroupEditViewController(groupId: 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
