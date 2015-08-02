import UIKit
import Bond

class MemberListViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource {

    var group = Group()
    var invitedList = DynamicArray<Member>([])
    var joiningList = DynamicArray<Member>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!

    @IBOutlet weak var memberListTableView: UITableView!

    init(group :Group) {
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
        // Dispose of any resources that can be recreated.
    }

    private func setupListData() {
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
        self.setupListData()

        // header
        let addButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Add,
            handler:{ (t) -> Void in
                var vc = InviteViewController(groupId: self.group.identifier.value)
                self.navigationController?.pushViewController(vc, animated: true)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItems = [addButton]

        // table
        self.memberListTableView.delegate = self
        self.memberListTableView.dataSource = self

        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.memberListTableView)
        self.tableViewDataSourceBond.nextDataSource = self.memberListTableView.dataSource

        self.memberListTableView.removeSeparatorsWhenUsingDefaultCell()

        let invitedSection = self.invitedList.map { [unowned self] (member: Member) -> UITableViewCell in
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            member.user.profile.displayName ->> cell.textLabel!.dynText
            return cell
        }
        let joinSection = self.joiningList.map { [unowned self] (member: Member) -> UITableViewCell in
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            member.user.profile.displayName ->> cell.textLabel!.dynText
            member.role.filter{$0 == "owner"}.map{"\($0)"} ->> cell.detailTextLabel!.dynText
//            member.role.filter{$0 == "owner"}.map{"\($0)"; return "aaaaaaaaa"} ->> cell.detailTextLabel!.dynText
            return cell
        }
        DynamicArray([invitedSection, joinSection]) ->> tableViewDataSourceBond
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
        //
    }

}
