//
//  NotificationListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/09.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import BlocksKit
import ObjectMapper
import Bond

class NotificationListViewController: BaseViewController,
    UITableViewDelegate {

    @IBOutlet weak var notificationTableView: UITableView!

    var list = DynamicArray<Notification>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!
    
    init() {
        super.init(nibName: "NotificationListViewController", bundle: nil)
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

        notificationTableView.delegate = self
//        notificationTableView.dataSource = self


        self.notificationTableView.estimatedRowHeight = 44
        self.notificationTableView.rowHeight = UITableViewAutomaticDimension

        notificationTableView.removeSeparatorsWhenUsingDefaultCell()
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.notificationTableView)
        
        self.navigationItem.title = kNavigationTitleNotificationList
        
        self.setBackButton()

        self.list.map { [unowned self] (notification:  Notification) -> NotificationTableViewCell in
            let cell = NotificationTableViewCell.getView("NotificationTableViewCell") as! NotificationTableViewCell
            notification.body ->> cell.notificationLabel.dynText
            return cell
        } ->> self.tableViewDataSourceBond
        
        self.requestNotifications()
    }
    
    func requestNotifications() {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.NotificationList()) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list.append(box.value)
                self.notificationTableView.reloadData()
                hideLoading()
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
            }
        }
    }

    // MARK: - UITableViewDataSource
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
////        cell.delegate = self
////        cell.setData()
//        
//        return cell
//    }

    // MARK: - UITableViewDelegate
    
//    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
//    {
//        return 88
//    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }

}
