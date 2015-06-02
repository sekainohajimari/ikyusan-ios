//
//  GroupEditViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class GroupEditViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemTableView: UITableView!
    
    var group :Group?
    
    let groupNameCellIdentifier = "groupNameCellIdentifier"
    let inviteCellIdentifier    = "inviteCellIdentifier"
    
    var itemList = [
        "グループ名",
        "招待する",
        "owner",
        "メンバー",
        "招待中"
    ]
    
    var memberList = [
        "shunsuke sato",
        "gfx"
    ]
    
    init(groupId :Int) {
        super.init(nibName: "GroupEditViewController", bundle: nil)
        
        // request -> Group
    }
    
    init(group :Group) {
        super.init(nibName: "GroupEditViewController", bundle: nil)
        
        self.group = group
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
        self.navigationItem.title = kNavigationTitleGroupEdit
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        self.setEndEditWhenViewTapped()
        
        var textInputTableViewCellNib = UINib(nibName: "TextInputTableViewCell", bundle:nil)
        self.itemTableView.registerNib(textInputTableViewCellNib, forCellReuseIdentifier: groupNameCellIdentifier)
        
        var inviteTableViewCellNib = UINib(nibName: "InviteTableViewCell", bundle:nil)
        self.itemTableView.registerNib(inviteTableViewCellNib, forCellReuseIdentifier: inviteCellIdentifier)
        
        let editButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                
                var cell = self.itemTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TextInputTableViewCell
                var name = cell.getText()
                if name.isEmpty {
                    return
                }
                if let g = self.group {
                    g.name = name
                    ApiHelper.sharedInstance.call(ApiHelper.UpdateGroup(group: g)) { response in
                        switch response {
                        case .Success(let box):
                            println(box.value)
                        case .Failure(let box):
                            println(box.value) // NSError
                        }
                    }
                }
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItems = [editButton]
    }
    
    func getTextInputTableViewCell(text :String, indexPath: NSIndexPath) -> TextInputTableViewCell {
        var cell = self.itemTableView.dequeueReusableCellWithIdentifier(groupNameCellIdentifier,
            forIndexPath: indexPath) as! TextInputTableViewCell
        cell.setPlaceholder(text)
        return cell
    }
    
    func getInviteTableViewCell(indexPath: NSIndexPath) -> InviteTableViewCell {
        var cell = self.itemTableView.dequeueReusableCellWithIdentifier(inviteCellIdentifier,
            forIndexPath: indexPath) as! InviteTableViewCell
        return cell
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 {
            return 1
        } else if section == 3 {
            return self.memberList.count
        } else {
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemList[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return self.getTextInputTableViewCell("グループ名を入力してください", indexPath: indexPath)
        } else if indexPath.section == 1 {
            return self.getInviteTableViewCell(indexPath)
        } else if indexPath.section == 2 {
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "r82"
            return cell
        } else if indexPath.section == 3 {
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = self.memberList[indexPath.row]
            return cell
        } else {
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "A_Y_A"
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }

}
