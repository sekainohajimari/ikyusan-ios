//
//  IdeaListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class IdeaListViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ideaTableView: UITableView!

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
        
        self.navigationItem.title = kNavigationTitleTopicList
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = list[indexPath.row]
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
