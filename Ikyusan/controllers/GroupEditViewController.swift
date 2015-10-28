import UIKit
import Bond

class GroupEditViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    GroupCreateViewControllerDelegate,
    InviteTableViewCellDelegate {
    
    @IBOutlet weak var itemTableView: UITableView!
    
    var group = Group()
    
    let list = [
        [
            ""    // グループ名を表示する
        ],
        [
            "メンバー",
            "グループ名と背景色設定"
        ],
        [
            "このグループを退室する"    // or "このグループを削除"
        ]
    ]
    
    init(inout group :Group) {
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

        self.group.colorCodeId.map { (colorId) -> UIColor in
            return GroupColor(rawValue: colorId)!.getColor()
        }.bindTo(self.navigationController!.navigationBar.bnd_tintColor)
//            ->> self.navigationController!.navigationBar.dynBarTintColor => PRすべき！？

        itemTableView.delegate = self
        itemTableView.dataSource = self

        self.setBackButton()

        if self.group.identifier.value != 0 {
            self.requestGroup(self.group.identifier.value, block: nil)
        }
    }

    // MARK: - private

    private func requestGroup(groupId :Int, block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.GroupDetail(groupId: groupId)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.group = box.value
                hideLoading()
                self.itemTableView.reloadData()
            case .Failure(let box):
                pri(box.value) // NSError
                hideLoading()
            }
            if let b = block {
                b()
            }
        }
    }

    private func refresh(block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.GroupDetail(groupId: self.group.identifier.value)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.group = box.value
                hideLoading()
                self.itemTableView.reloadData()
            case .Failure(let box):
                pri(box.value) // NSError
                hideLoading()
            }
            if let b = block {
                b()
            }
        }
    }

    private func getJoinMemberCount() -> Int {
        var count = 0
        for member in self.group.groupMembers {
            if member.status.value == "joining" {
                count++
            }
        }
        return count
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.textLabel?.text = self.list[indexPath.section][indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        if indexPath.section == 0 {
            let memberCount = self.getJoinMemberCount()
            self.group.name.map { (text) -> String in
                return "\(text) (\(memberCount)人)"
            }.bindTo(cell.textLabel!.bnd_text)
        }

        if indexPath.section == 2 {
            if self.group.hasOwner.value {
                cell.textLabel?.text = "このグループを削除"
            }
        }

        if indexPath.section == 1 || indexPath.section == 2 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        if indexPath.section == 0 {
            return 88
        }

        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                let vc = MemberListViewController(group: &self.group)// memo: 参照渡ししてみる・・・うまくいくかな？？
                //                    vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = GroupCreateViewController(group: &self.group)
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                self.presentViewController(nav, animated: true, completion: nil)
            }
        case 2:
            let alert = UIAlertController(title: "本当によろしいですか？", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "いいえ", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "はい", style: UIAlertActionStyle.Default, handler: { (action) -> Void in

                if self.group.hasOwner.value {
                    ApiHelper.sharedInstance.call(ApiHelper.DeleteGroup(groupId: self.group.identifier.value)) { response in
                        hideLoading()
                        switch response {
                        case .Success(let box):

                            let notification = NSNotification(name: kNotificationGroupChange, object: nil)
                            NSNotificationCenter.defaultCenter().postNotification(notification)

                            self.dismissViewControllerAnimated(true, completion: nil)

                        case .Failure(let box):
                            pri(box.value) // NSError
                            showError("error!!")
                        }
                    }
                } else {
                    ApiHelper.sharedInstance.call(ApiHelper.EscapeGroup(groupId: self.group.identifier.value)) { response in
                        hideLoading()
                        switch response {
                        case .Success(let box):

                            let notification = NSNotification(name: kNotificationGroupChange, object: nil)
                            NSNotificationCenter.defaultCenter().postNotification(notification)

                            self.dismissViewControllerAnimated(true, completion: nil)

                        case .Failure(let box):
                            pri(box.value) // NSError
                            showError("error!!")
                        }
                    }
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)

        default:
            break
        }
    }
    
    // MARK: - 
    
    func inviteTableViewCellInviteButtonTapped(name :String) {
        ApiHelper.sharedInstance.call(ApiHelper.InviteGroup(groupId: self.group.identifier.value, targetDisplayId: name)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                hideLoading()
                ToastHelper.make(self.view, message: name + "さんを招待しました")
            case .Failure(let box):
                pri(box.value) // NSError
                hideLoading()
            }
        }
    }

    // MARK: - GroupCreateViewControllerDelegate

    func groupCreateViewControllerUpdated() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            ToastHelper.make(self.view, message: "更新しました")
//            self.navigationController!.navigationBar.barTintColor = GroupColor(rawValue: self.group.colorCodeId.value)!.getColor() // TODO: 微妙・・・
        })
    }


}
