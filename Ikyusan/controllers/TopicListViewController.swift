import UIKit
import BlocksKit
import ObjectMapper
import Bond

class TopicListViewController: BaseViewController,
    UITableViewDelegate,
    TopicCreateViewControllerDelegate {
    
    @IBOutlet weak var topicTableView: UITableView!
    @IBOutlet weak var postButton: UIButton!

    var group :Group

    var list = DynamicArray<Topic>([])
    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!

    init(group :Group) {
        self.group = group
        super.init(nibName: "TopicListViewController", bundle: nil)
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


    // MARK: - private
    
    private func setup() {

        // header
        self.setCloseButton(nil)
        self.setBackButton()

        self.group.name ->> self.navigationItem.dynTitle

        let editButton = UIBarButtonItem().bk_initWithTitle("編集", style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            var vc = GroupEditViewController(group: &self.group)
            self.navigationController?.pushViewController(vc, animated: true)
            } as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = editButton

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        map(self.group.colorCodeId) { colorId in
            return GroupColor(rawValue: colorId)!.getColor()
        } ->> self.navigationController!.navigationBar.dynBarTintColor

//        self.navigationController?.navigationBar.barTintColor = GroupColor(rawValue: self.group.colorCodeId.value)?.getColor()
        self.navigationController?.navigationBar.alpha = 1.0

        // table
        topicTableView.delegate = self
        topicTableView.removeSeparatorsWhenUsingDefaultCell()
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.topicTableView)

        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.topicTableView.addSubview(refresh)

        self.list.map { [unowned self] (topic: Topic) -> UITableViewCell in
            let cell = TopicTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            topic.name ->> cell.textLabel!.dynText
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } ->> self.tableViewDataSourceBond

        self.postButton.setTitleColor(GroupColor(rawValue: self.group.colorCodeId.value)?.getColor(), forState: UIControlState.Normal)

        requestTopics(self.group.identifier.value, block: nil)
    }
    
    @objc func onRefresh(sender:UIRefreshControl) {
        self.list.removeAll(false)
        self.requestTopics(self.group.identifier.value) { () -> Void in
            sender.endRefreshing()
        }
    }
    
    private func requestTopics(groupId :Int, block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.TopicList(groupId: groupId)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list.removeAll(false)
                for topic in box.value {
                    self.list.append(topic)
                }
            case .Failure(let box):
                println(box.value)
                showError(message: "error")
            }
            hideLoading()
            if let b = block {
                b()
            }
        }
    }

    // MARK: - IB action

    @IBAction func createButtonTapped(sender: AnyObject) {
        var vc = TopicEditViewController(
            groupId:     self.group.identifier.value,
            colorCodeId: self.group.colorCodeId.value,
            topicId:     nil,
            topicName:   nil)
        vc.delegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = IdeaListViewController(
            groupId:     self.group.identifier.value,
            topicId:     self.list[indexPath.row].identifier.value,
            colorCodeId: self.group.colorCodeId.value)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // try new usability
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.topicTableView.contentOffset.y > 80 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: - TopicCreateViewControllerDelegate

    func topicCreateViewControllerUpdated() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.requestTopics(self.group.identifier.value, block: { () -> Void in
                ToastHelper.make(self.view, message: "トピックを作成しました")
            })
        })
    }

}
