import UIKit
import BlocksKit
import ObjectMapper
import Bond
import SloppySwiper

class GroupListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    GroupCreateViewControllerDelegate {

    @IBOutlet weak var groupTableView: UITableView!

    var invitedList = DynamicArray<Group>([])
    var joiningList = DynamicArray<Group>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!


    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidAppear(animated: Bool) {

        var grayColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = grayColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:grayColor]

        self.navigationController?.navigationBar.barTintColor = kBaseNabigationColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {

        setupHeader()

        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self

        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.groupTableView)
        self.tableViewDataSourceBond.nextDataSource = self.groupTableView.dataSource

        self.groupTableView.removeSeparatorsWhenUsingDefaultCell()

        let invitedSection = self.invitedList.map { [unowned self] (group: Group) -> UITableViewCell in
            let cell = self.aaa() as! GroupTableViewCell
            group.name ->> cell.nameLabel.dynText
            cell.colorView.backgroundColor = GroupColor(rawValue: group.colorCodeId.value)?.getColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.editButton.hidden = true
            return cell
        }
        let joinSection = self.joiningList.map { [unowned self] (group: Group) -> UITableViewCell in
            let cell = self.aaa() as! GroupTableViewCell
            group.name ->> cell.nameLabel.dynText
//            GroupColor(rawValue: group.colorCodeId.value)?.getColor() ->> cell.colorView.dynBackgroundColor
            cell.colorView.backgroundColor = GroupColor(rawValue: group.colorCodeId.value)?.getColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.editButton.dynEvent.filter(==, .TouchUpInside) ->> self.editTapListener
//            cell.editButton.dynEvent.filter(==, .TouchUpInside).rewrite(cell.editButton.dynEvent) ->> self.editTapListener
            return cell
        }
        DynamicArray([invitedSection, joinSection]) ->> tableViewDataSourceBond
        
        self.requestGroups(nil)
    }

    lazy var editTapListener: Bond<UIControlEvents> = Bond() { [unowned self] event in
        var vc = GroupEditViewController(groupId: 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func aaa() -> UIView {
        var nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        var views = nib.instantiateWithOwner(self, options: nil)
        return views[0] as! UIView
    }

    private func setupHeader() {
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
    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.invitedList = DynamicArray<Group>([])
        self.joiningList = DynamicArray<Group>([])
        self.requestGroups { () -> Void in
            sender.endRefreshing()
        }
    }
    
    private func requestGroups(block :(() -> Void)?) {
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

    private func showActionForJoinOrNot(groupId :Int) {
        var actionSheet = UIAlertController(title: nil,
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        actionSheet.addAction(UIAlertAction(title: "グループに参加する", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                ApiHelper.sharedInstance.call(ApiHelper.JoinGroup(groupId: groupId)) { response in
                    switch response {
                    case .Success(let box):
                        println(box.value)
                        hideLoading()
                        var invitedList = DynamicArray<Group>([])
                        var joiningList = DynamicArray<Group>([])
                        self.requestGroups(nil) //temp
                    case .Failure(let box):
                        println(box.value) // NSError
                        hideLoading()
                    }
                }
        }))
        actionSheet.addAction(UIAlertAction(title: "拒否", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                // API調整中
        }))
        actionSheet.addAction(UIAlertAction(title: "閉じる", style: UIAlertActionStyle.Cancel,
            handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
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
        case 0 : return "招待されたグループ(" + String(self.invitedList.count) + ")"
        case 1 : return "グループ(" + String(self.joiningList.count) + ")"
        default : return ""
        }
    }

    // テーブルビューのヘッダの色を変える
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.darkGrayColor()
        header.textLabel.font = UIFont.systemFontOfSize(11)
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
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        return cell
    }


    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            var group = self.invitedList[indexPath.row]
            self.showActionForJoinOrNot(group.identifier.value)
        } else {
            var group = self.joiningList[indexPath.row]
            let groupId = group.identifier.value
            let colorCodeId = group.colorCodeId.value
            var vc = TopicListViewController(groupId: groupId, colorCodeId: colorCodeId)
            self.navigationController?.pushViewController(vc, animated: true)

//            var nav = UINavigationController(rootViewController: vc)
//            var swiper = SloppySwiper(navigationController: nav)
//            nav.delegate = swiper

//            self.presentViewController(nav, animated: true, completion: nil)
        }
    }

    // MARK: - GroupCreateViewControllerDelegate

    func groupCreateViewControllerUpdated() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.invitedList = DynamicArray<Group>([])
            self.joiningList = DynamicArray<Group>([])
            self.requestGroups { () -> Void in
                ToastHelper.make(self.view, message: "グループを作成しました")
            }
        })
    }

}
