import UIKit
import SWTableViewCell
import BlocksKit
import ObjectMapper
import Bond

class GroupListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    GroupCreateViewControllerDelegate,
    SWTableViewCellDelegate {

    @IBOutlet weak var groupTableView: UITableView!

    var invitedList = DynamicArray<Group>([])
    var joiningList = DynamicArray<Group>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<SWTableViewCell>!


    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = kBaseNabigationColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self

        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.groupTableView)
        self.tableViewDataSourceBond.nextDataSource = self.groupTableView.dataSource

        self.groupTableView.removeSeparatorsWhenUsingDefaultCell()

        let invitedSection = self.invitedList.map { [unowned self] (group: Group) -> UITableViewCell in
            let cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.delegate = self
            cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
            group.name ->> cell.textLabel!.dynText
            return cell
        }

        let joinSection = self.joiningList.map { [unowned self] (group: Group) -> UITableViewCell in
            let cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.delegate = self
            cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
            group.name ->> cell.textLabel!.dynText
            return cell
        }
        DynamicArray([invitedSection, joinSection]) ->> tableViewDataSourceBond
        
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
        showLoading()

        ApiHelper.sharedInstance.call(ApiHelper.GroupList()) { response in
            switch response {
            case .Success(let box):
                hideLoading()
                println(box.value)
                for group in box.value {
                    if (group as Group).status.value == GroupType.Join {
                        self.joiningList.append(group)
                    } else if (group as Group).status.value == GroupType.Invited {
                        self.invitedList.append(group)
                    }
                }
                self.groupTableView.reloadData()
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

    @IBAction func addButtonTapped(sender: AnyObject) {
        var vc = GroupCreateViewController()
        vc.delegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }


    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "招待されているグループ"
        case 1 : return "参加しているグループ"
        default : return ""
        }
    }

    // テーブルビューのヘッダの色を変える
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.darkGrayColor()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // no used...but need for swift bond
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // no used...but need for swift bond
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // no used...but need for swift bond
        var cell = SWTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        return cell
    }


    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            //
        } else {
            var group = self.joiningList[indexPath.row]
            let groupId = group.identifier.value
            let colorCodeId = group.colorCodeId.value
            var vc = TopicListViewController(groupId: groupId, colorCodeId: colorCodeId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
//        if index == 0 {
//            var vc = GroupEditViewController(group: self.list[index])
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }

    // MARK: - XXXXX

    func groupCreateViewControllerUpdated() {
        self.navigationController?.popViewControllerAnimated(true)
        self.requestGroups { () -> Void in
            ToastHelper.make(self.view, message: "グループを作成しました")
        }
    }

}
