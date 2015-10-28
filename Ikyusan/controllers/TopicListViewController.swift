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

    var list = ObservableArray<Topic>([])

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

        self.group.name.bindTo(self.navigationItem.bnd_title)

        let editButton = UIBarButtonItem().bk_initWithTitle("編集", style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            let vc = GroupEditViewController(group: &self.group)
            self.navigationController?.pushViewController(vc, animated: true)
            } as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = editButton

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        self.group.colorCodeId.map { colorId in
            return GroupColor(rawValue: colorId)!.getColor()
        }.bindTo(self.navigationController!.navigationBar.bnd_barTintColor) // PR

//        self.navigationController?.navigationBar.barTintColor = GroupColor(rawValue: self.group.colorCodeId.value)?.getColor()
        self.navigationController?.navigationBar.alpha = 1.0

        // table
        topicTableView.delegate = self
        topicTableView.removeSeparatorsWhenUsingDefaultCell()

        let refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.topicTableView.addSubview(refresh)

        self.list.lift().bindTo(self.topicTableView) { (indexPath, array, tableView) -> UITableViewCell in
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let topic = array[0][indexPath.row]
            topic.name.bindTo(cell.textLabel!.bnd_text)
            return cell
        }

        self.postButton.setTitleColor(GroupColor(rawValue: self.group.colorCodeId.value)?.getColor(), forState: UIControlState.Normal)

        requestTopics(self.group.identifier.value, block: nil)
    }
    
    @objc func onRefresh(sender:UIRefreshControl) {
        self.list.removeAll()
        self.requestTopics(self.group.identifier.value) { () -> Void in
            sender.endRefreshing()
        }
    }
    
    private func requestTopics(groupId :Int, block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.TopicList(groupId: groupId)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.list.removeAll()
                for topic in box.value {
                    self.list.append(topic)
                }
            case .Failure(let box):
                pri(box.value)
                showError("error")
            }
            hideLoading()
            if let b = block {
                b()
            }
        }
    }

    // MARK: - IB action

    @IBAction func createButtonTapped(sender: AnyObject) {
        let vc = TopicEditViewController(
            groupId:     self.group.identifier.value,
            colorCodeId: self.group.colorCodeId.value,
            topicId:     nil,
            topicName:   nil)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = IdeaListViewController(
            groupId:     self.group.identifier.value,
            topicId:     self.list[indexPath.row].identifier.value,
            colorCodeId: self.group.colorCodeId.value,
            topicName:   self.list[indexPath.row].name.value)
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
