import UIKit
import BlocksKit
import Bond

class AccountEditViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    AvatarSettingTableViewCellDelegate {
    
    @IBOutlet weak var accountEditTableView: UITableView!

    var firstAvatarChangeFlg = false

    let list = [
        [
            "(avatarImage)"
        ],
        [
            "ID",
            "名前",
            "ログインアカウント"
        ],
        [
            "お問い合わせ/フィードバック"
        ],
        [
            "ログアウト",
            "アカウント削除"
        ],
    ]

    var profile = Profile()
    
    init() {
        super.init(nibName: "AccountEditViewController", bundle: nil)
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

    func setupTableView() {
        self.accountEditTableView.delegate = self
        self.accountEditTableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list[section].count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            var cell = AvatarSettingTableViewCell.aaa() as! AvatarSettingTableViewCell
            var url = NSURL(string: self.profile.iconUrl.value)
            var data = NSData(contentsOfURL: url!)
            if data != nil {
                var image = UIImage(data: data!)!
                cell.setAvatarImage(image)
            }
            cell.delegate = self
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
                cell.textLabel?.text = self.list[indexPath.section][indexPath.row]
                cell.detailTextLabel?.text = self.profile.displayId.value
                return cell
            case 1:
                var cell = TextInputTableViewCell.aaa() as! TextInputTableViewCell
                self.profile.displayName <->> cell.textField.dynText
                return cell
            case 2:
                var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
                cell.textLabel?.text = self.list[indexPath.section][indexPath.row]
                cell.detailTextLabel?.text = "Twitter"
                return cell
            default:
                return UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "")
            }
        case 2:
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = self.list[indexPath.section][indexPath.row]
            return cell
        case 3:
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = self.list[indexPath.section][indexPath.row]
            return cell
        default:
            return UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "")
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        if indexPath.section == 0 {
            return 120
        }
        
        return 44
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                AccountHelper.sharedInstance.deleteAccessToken()
                var vc = TwitterAuthViewController(nibName: "TwitterAuthViewController", bundle: nil)
                var nav = UINavigationController(rootViewController: vc)
                self.presentViewController(nav, animated: true, completion: nil)
            default:
                return
            }
        default:
            return
        }
    }




    
    
    func setup() {
        self.navigationItem.title = kNavigationTitleAccountEdit

        self.setupTableView()
        
        let saveButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Save,
            handler:{ (t) -> Void in
                showLoading()
                ApiHelper.sharedInstance.call(ApiHelper.ProfileEdit(displayId: self.profile.displayId.value,
                    name: self.profile.displayName.value)) { response in
                    switch response {
                    case .Success(let box):
                        println(box.value)
                        self.profile = box.value
                        hideLoading()
                        self.navigationController?.popViewControllerAnimated(true)
                    case .Failure(let box):
                        println(box.value) // NSError
                        hideLoading()
                    }
                }
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.requestProfile()
    }
    
//    func setupBond() {
//        self.profile.displayName <->> self.nameLabel.dynText
//
//        // TODO: refactor
//        self.profile.iconUrl.map { (str :String) -> UIImage in
//            var url = NSURL(string: str)
//            if let existUrl = url {
//                var data = NSData(contentsOfURL: existUrl)
//                if let existData = data {
//                    return UIImage(data: existData)!
//                } else {
//                    return UIImage()
//                }
//            } else {
//                return UIImage()
//            }
//        } ->> self.profileImageView.dynImage
//    }

    func requestProfile() {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.ProfileInfo()) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.profile = box.value
                hideLoading()
                self.accountEditTableView.reloadData()
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
            }
        }
    }

    func avatarSettingTapped() {
        
    }


    // MARK: - IB action
    
//    @IBAction func profileImageButtonTapped(sender: AnyObject) {
//        var alert = UIAlertController(title: nil,
//            message: kMessageRemoveAvatar,
//            preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "いいえ",
//            style: UIAlertActionStyle.Default,
//            handler: { (action :UIAlertAction!) -> Void in
//                //
//        }))
//        alert.addAction(UIAlertAction(title: "はい",
//            style: UIAlertActionStyle.Default,
//            handler: { (action :UIAlertAction!) -> Void in
//                //
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }


}
