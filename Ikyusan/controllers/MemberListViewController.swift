import UIKit
import Bond

class MemberListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    InviteViewControllerDelegate {

    var group = Group()
    var invitedList = ObservableArray<Member>([])
    var joiningList = ObservableArray<Member>([])

    @IBOutlet weak var memberListTableView: UITableView!

    init(inout group :Group) {
        super.init(nibName: "MemberListViewController", bundle: nil)
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
    }

    private func setupMemberListData() {
        for member in self.group.groupMembers {
            if member.status.value == GroupType.Join.rawValue {
                self.joiningList.append(member)
            } else if member.status.value == GroupType.Invited.rawValue {
                self.invitedList.append(member)
            }
        }
    }

    private func setup() {

        // data
        self.setupMemberListData()

        // header
        self.navigationItem.title = kNavigationMemberList
        self.setBackButton()
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                let vc = InviteViewController(groupId: self.group.identifier.value)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItems = [addButton]

        // table
        self.memberListTableView.delegate = self
        self.memberListTableView.dataSource = self
        self.memberListTableView.removeSeparatorsWhenUsingDefaultCell()

        self.invitedList.lift().bindTo(self.memberListTableView) { (indexPath, array, tableView) -> UITableViewCell in
            let cell = MemberTableViewCell.getView("MemberTableViewCell") as! MemberTableViewCell
            let member = array[0][indexPath.row]

            member.user.profile.iconUrl.deliverOn(Queue.Background).map { (urlString) -> UIImage in
                let url = NSURL(string: urlString)
                let data = NSData(contentsOfURL: url!)
                if let existData = data {
                    return UIImage(data: existData)!
                } else {
                    return UIImage()
                }
            }.deliverOn(Queue.Main).bindTo(cell.avatarImageView.bnd_image)

            member.user.profile.displayName.bindTo(cell.nameLabel!.bnd_text)

            return cell
        }

        self.joiningList.lift().bindTo(self.memberListTableView) { (indexPath, array, tableView) -> UITableViewCell in
            let cell = MemberTableViewCell.getView("MemberTableViewCell") as! MemberTableViewCell
            let member = array[0][indexPath.row]

            member.user.profile.iconUrl.deliverOn(Queue.Background).map { (urlString) -> UIImage in
                let url = NSURL(string: urlString)
                let data = NSData(contentsOfURL: url!)
                if let existData = data {
                    return UIImage(data: existData)!
                } else {
                    return UIImage()
                }
                }.deliverOn(Queue.Main).bindTo(cell.avatarImageView.bnd_image)

            member.user.profile.displayName.bindTo(cell.nameLabel!.bnd_text)

//            member.role.filter{$0 == "owner"}.rewrite("管理者").bindTo(cell.subLabel!.bnd_text)

            self.group.colorCodeId.map { (colorCodeId) -> UIColor in
                return GroupColor(rawValue: colorCodeId)!.getColor()
            }.bindTo(cell.subLabel!.bnd_textColor)

            return cell
        }

//        ObservableArray([invitedSection, joinSection]) ->> tableViewDataSourceBond ?? どうするここ？？
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "招待中のメンバー"
        case 1 : return "メンバー"
        default : return ""
        }
    }

    // テーブルビューのヘッダの色を変える
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.darkGrayColor()
        header.textLabel!.font = UIFont.systemFontOfSize(11)
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
        //
    }

    // MARK: - InviteViewControllerDelegate

    func inviteViewControllerCompleted(invite :Invite) {
        // TODO: 微妙やな、、、ここらへん
        let member = Member()
        member.status.value = GroupType.Invited.rawValue
        member.user         = invite.inviteUser

        self.invitedList.append(member)
        self.group.groupMembers.append(member)
    }

}
