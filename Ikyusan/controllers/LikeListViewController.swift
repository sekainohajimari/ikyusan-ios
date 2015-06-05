//
//  LikeListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class LikeListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var likeTableView: UITableView!
    
    var list = [Like]()
    
    var groupId :Int
    var topicId :Int
    var ideaId  :Int
    
    init(groupId :Int, topicId :Int, ideaId :Int) {
        self.groupId = groupId
        self.topicId = topicId
        self.ideaId  = ideaId
        super.init(nibName: "LikeListViewController", bundle: nil)
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
        likeTableView.delegate = self
        likeTableView.dataSource = self
        likeTableView.removeSeparatorsWhenUsingDefaultCell()
        
        self.navigationItem.title = kNavigationTitleLikeList
        
        self.setBackButton()
        
        self.requestLikes(self.groupId, topicId:self.topicId, ideaId:self.ideaId)
    }
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "delete")
        return buttons
    }
    
    func requestLikes(groupId :Int, topicId :Int, ideaId :Int) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.LikeList(groupId: groupId, topicId: topicId, ideaId: ideaId)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list = box.value
                self.likeTableView.reloadData()
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
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")

        cell.textLabel?.text = "test" //list[indexPath.row].
        if let num = list[indexPath.row].num {
            cell.detailTextLabel?.text = String(num)
        }
        return cell
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
