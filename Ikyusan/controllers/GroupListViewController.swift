import UIKit
import BlocksKit
import ObjectMapper
import Bond
import SloppySwiper
import UIBarButtonItem_Badge

class GroupListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    SignupViewControllerDelegate,
    AccountEditViewControllerDelegate,
    GroupCreateViewControllerDelegate {

    @IBOutlet weak var groupTableView: UITableView!

    var swiper = SloppySwiper()

    var invitedList = DynamicArray<Group>([])
    var joiningList = DynamicArray<Group>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!

    var notificationButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidAppear(animated: Bool) {

        self.navigationController?.navigationBar.tintColor = kBaseNavigationStringColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:kBaseNavigationStringColor]
        self.navigationController?.navigationBar.barTintColor = kBaseNavigationColor

        ApiHelper.sharedInstance.call(ApiHelper.NotificationCount()) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.notificationButton.badgeValue = String(stringInterpolationSegment: box.value)
            case .Failure(let box):
                pri(box.value)
                // alertとかはあげない
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - private
    
    private func setup() {

        self.setupObservers()

        self.setupHeader()

        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.groupTableView.removeSeparatorsWhenUsingDefaultCell()

        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.groupTableView)
        self.tableViewDataSourceBond.nextDataSource = self.groupTableView.dataSource

        let invitedSection = self.invitedList.map { [unowned self] (group: Group) -> UITableViewCell in
            let cell = GroupTableViewCell.getView("GroupTableViewCell") as! GroupTableViewCell
            group.name ->> cell.nameLabel.dynText
            group.colorCodeId.map { colorId in
                return GroupColor(rawValue: colorId)!.getColor()
                } ->> cell.colorView.dynBackgroundColor
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        let joinSection = self.joiningList.map { [unowned self] (group: Group) -> UITableViewCell in
            let cell = GroupTableViewCell.getView("GroupTableViewCell") as! GroupTableViewCell
            group.name ->> cell.nameLabel.dynText
            group.colorCodeId.map { colorId in
                return GroupColor(rawValue: colorId)!.getColor()
            } ->> cell.colorView.dynBackgroundColor
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        DynamicArray([invitedSection, joinSection]) ->> tableViewDataSourceBond

        // login check
        if AccountHelper.sharedInstance.getAccessToken() == nil {
            var vc = SignupViewController(nibName: "SignupViewController", bundle: nil)
            vc.delegate = self
            var nav = UINavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true, completion: nil)
        } else {
            self.requestGroups(nil)
        }
    }

    private func setupHeader() {
        self.navigationItem.title = kNavigationTitleGroupList

        self.setBackButton()

        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.groupTableView.addSubview(refresh)

        let settingButton = UIBarButtonItem().bk_initWithImage(UIImage(named: "icon_account"), style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            var vc = AccountEditViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = settingButton

        self.notificationButton = UIBarButtonItem().bk_initWithImage(UIImage(named: "icon_bell"), style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            var vc = NotificationListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } as! UIBarButtonItem
        self.navigationItem.rightBarButtonItems = [self.notificationButton]
    }

    private func setupObservers() {
        // memo: 一番のベースのクラスなのでdeinitに書くremoveObserverの処理は書かない
        NSNotificationCenter.defaultCenter().addObserverForName(kNotificationGroupChange, object: nil, queue: nil) { (n) -> Void in
            self.requestGroups(nil)
        }
    }
    
    @objc func onRefresh(sender:UIRefreshControl) {
        self.requestGroups { () -> Void in
            sender.endRefreshing()
        }
    }
    
    private func requestGroups(block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.GroupList()) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.invitedList.removeAll(false)
                self.joiningList.removeAll(false)
                for group in box.value {
                    if (group as Group).status.value == GroupType.Join {
                        self.joiningList.append(group)
                    } else if (group as Group).status.value == GroupType.Invited {
                        self.invitedList.append(group)
                    }
                }
                self.groupTableView.reloadData()
                hideLoading()
            case .Failure(let box):
                pri(box.value)
                hideLoading()
                showError(message: kMessageCommonError)
            }
            block?()
        }
    }

    private func showActionForJoinOrNot(groupId :Int) {
        let actionSheet = UIAlertController(title: nil,
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        actionSheet.addAction(UIAlertAction(title: "グループに参加する", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                ApiHelper.sharedInstance.call(ApiHelper.JoinGroup(groupId: groupId)) { response in
                    switch response {
                    case .Success(let box):
                        pri(box.value)
                        hideLoading()
                        self.requestGroups(nil) //temp
                    case .Failure(let box):
                        pri(box.value) // NSError
                        hideLoading()
                    }
                }
        }))
        actionSheet.addAction(UIAlertAction(title: "拒否", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                ApiHelper.sharedInstance.call(ApiHelper.RejectGroup(groupId: groupId)) { response in
                    switch response {
                    case .Success(let box):
                        pri(box.value)
                        hideLoading()
                        self.requestGroups(nil) //temp
                    case .Failure(let box):
                        pri(box.value) // NSError
                        hideLoading()
                    }
                }
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

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // テーブルビューのヘッダの色を変える
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
        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let group = self.invitedList[indexPath.row]
            self.showActionForJoinOrNot(group.identifier.value)
        } else {
            let group = self.joiningList[indexPath.row]
            let groupId     = group.identifier.value
            let colorCodeId = group.colorCodeId.value
            let name        = group.name.value
            var vc = TopicListViewController(group: group)
            var nav = UINavigationController(rootViewController: vc)
            self.swiper = SloppySwiper(navigationController: nav)
            nav.delegate = self.swiper

            dispatch_async_main { [unowned self] in  // TODO: why??
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }

    // MARK: - GroupCreateViewControllerDelegate

    func groupCreateViewControllerUpdated() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.requestGroups { () -> Void in
                ToastHelper.make(self.view, message: "グループを作成しました")
            }
        })
    }

    // MARK: - SignupViewControllerDelegate

    func signupCompleted() {
        self.requestGroups(nil)
    }

    // MARK: - AccountEditViewControllerDelegate

    func accountEditViewAcountChanged() {
        self.navigationController?.popViewControllerAnimated(true)
        self.requestGroups(nil)
    }

}
