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

class IdeaListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    SWTableViewCellDelegate,
    UIActionSheetDelegate,
    AskIdeaViewDelegate {
    
    @IBOutlet weak var ideaTableView: UITableView!
    
    let ideaCellIdentifier = "ideacell"

    var list = [
        "旅行の話",
        "ものをなくす話",
        "タコベル 食レポ報告",
        "なゆみがー　くるー",
        "うしさんに落語について訊こう",
    ]
    
    init(topicId :Int) {
        super.init(nibName: "IdeaListViewController", bundle: nil)
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
        
        self.setBackButton()
        
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                var vc = IdeaPostViewController()
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        
        let sortButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Search,
            handler:{ (t) -> Void in
            self.showSortActionSheet()
        }) as! UIBarButtonItem
        
        self.navigationItem.rightBarButtonItems = [addButton, sortButton]
        
        var nib  = UINib(nibName: "IdeaTableViewCell", bundle:nil)
        self.ideaTableView.registerNib(nib, forCellReuseIdentifier: ideaCellIdentifier)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "delete")
        return buttons
    }
    
    func showSortActionSheet() {
        var actionSheet = UIAlertController(title: "アイデアをソートする",
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "人気順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                //
        }))
        actionSheet.addAction(UIAlertAction(title: "新しい順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                //
        }))
        actionSheet.addAction(UIAlertAction(title: "古い順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                //
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel,
            handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ideaCellIdentifier,
            forIndexPath: indexPath) as! IdeaTableViewCell
        cell.delegate = self
        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
//        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = LikeListViewController(ideaId: 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footer = AskIdeaView.loadFromNib() as? AskIdeaView
        footer?.delegate = self
        return footer
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0 {
            self.view.makeToast("delete!!")
        }
    }
    
    // MARK: - AskIdeaViewDelegate
    
    func askIdeaViewTapped() {
        self.view.makeToast("hello, Ikyusan")
    }

}
