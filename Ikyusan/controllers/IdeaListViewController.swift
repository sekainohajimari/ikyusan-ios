//
//  IdeaListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import SWTableViewCell
import Toast
import ObjectMapper

class IdeaListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    SWTableViewCellDelegate,
    UIActionSheetDelegate,
    AskIdeaViewDelegate,
    IdeaTableViewCellDelegate,
    IdeaPostViewControllerDelegate {
    
    @IBOutlet weak var ideaTableView: UITableView!
    
    let ideaCellIdentifier = "ideaCellIdentifier"

    var groupId :Int
    var topicId :Int
    
    var list = [Idea]()
    
    init(groupId :Int, topicId :Int) {
        self.groupId = groupId
        self.topicId = topicId
        
        super.init(nibName: "IdeaListViewController", bundle: nil)
        
        LikeHelper.sharedInstance.setBaseInfo(groupId, topicId: topicId)
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
        ideaTableView.delegate = self
        ideaTableView.dataSource = self
        ideaTableView.removeSeparatorsWhenUsingDefaultCell()
        
        self.navigationItem.title = kNavigationTitleIdeaList
        
        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.ideaTableView.addSubview(refresh)
        
        self.setBackButton()
        
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                var vc = IdeaPostViewController(groupId: self.groupId, topicId: self.topicId)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        
        let sortButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Search,
            handler:{ (t) -> Void in
            self.showSortActionSheet()
        }) as! UIBarButtonItem
        
        self.navigationItem.rightBarButtonItems = [addButton, sortButton]
        
        var nib  = UINib(nibName: "IdeaTableViewCell", bundle:nil)
        self.ideaTableView.registerNib(nib, forCellReuseIdentifier: ideaCellIdentifier)
        
        self.requestIdeas(self.groupId, topicId: self.topicId, block: nil)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "delete")
        return buttons
    }
    
    func showSortActionSheet() {
        var actionSheet = UIAlertController(title: "アイデアをソートする",
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // TODO:needs refactor
        actionSheet.addAction(UIAlertAction(title: "人気順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                self.list.sort({ (prev :Idea, next :Idea) -> Bool in
                    return prev.likeCount > next.likeCount
                })
                self.ideaTableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "新しい順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                self.list.sort({ (prev :Idea, next :Idea) -> Bool in
                    return (prev.createdAt!.getDate().compare(next.createdAt!.getDate()) == NSComparisonResult.OrderedDescending)
                })
                self.ideaTableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "古い順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                self.list.sort({ (prev :Idea, next :Idea) -> Bool in
                    return (prev.createdAt!.getDate().compare(next.createdAt!.getDate()) == NSComparisonResult.OrderedAscending)
                })
                self.ideaTableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel,
            handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.requestIdeas(self.groupId, topicId: self.topicId) { () -> Void in
            sender.endRefreshing()
            //            self.groupTableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func requestIdeas(groupId :Int, topicId :Int, block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.IdeaList(groupId: groupId, topicId: topicId)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list = box.value
                self.ideaTableView.reloadData()
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
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ideaCellIdentifier,
            forIndexPath: indexPath) as! IdeaTableViewCell
        cell.delegate = self
        cell.ideaTableViewCellDelegate = self
        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
        cell.setData(list[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return IdeaTableViewCell.getCellHeight(list[indexPath.row],
            parentWidth: self.ideaTableView.getWidth())
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var targetIdeaId = self.list[indexPath.row].identifier
        if let ideaId = targetIdeaId {
            var vc = LikeListViewController(groupId: self.groupId, topicId: self.topicId, ideaId: ideaId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 88
//    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var footer = AskIdeaView.loadFromNib() as? AskIdeaView
//        footer?.delegate = self
//        return footer
//    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            if let idea = (cell as! IdeaTableViewCell).data {
                ApiHelper.sharedInstance.call(ApiHelper.DeleteIdea(groupId: groupId, topicId: topicId, ideaId: idea.identifier!)) { response in
                    switch response {
                    case .Success(let box):
                        println(box.value)
                        self.list = box.value
                        self.ideaTableView.reloadData()
                        hideLoading()
                        self.view.makeToast("削除しました")
                    case .Failure(let box):
                        println(box.value) // NSError
                        hideLoading()
                    }
                }
            }
        }
    }
    
    // MARK: - AskIdeaViewDelegate
    
    func askIdeaViewTapped() {
        self.view.makeToast("hello, Ikyusan")
    }
    
    // MARK: - IdeaTableViewCellDelegate
    
    func ideaTableViewCellLikeButtonTapped(idea :Idea) {
        LikeHelper.sharedInstance.doLike(idea.identifier!)
    }
    
    // MARK: - IdeaPostViewControllerDelegate
    
    func ideaPostViewControllerUpdated(ideas :[Idea]) {
        self.navigationController?.popViewControllerAnimated(true)
        self.list = ideas
        self.ideaTableView.reloadData()
        self.view.makeToast("ネタを投稿しました")
    }

}
