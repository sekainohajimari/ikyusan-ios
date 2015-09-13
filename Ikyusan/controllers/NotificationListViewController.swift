import UIKit
import BlocksKit
import ObjectMapper
import Bond
import SVPullToRefresh

class NotificationListViewController: BaseViewController,
    UITableViewDelegate {

    @IBOutlet weak var notificationTableView: UITableView!

    var page = 1
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
    }
    
    func setup() {

        // header
        self.navigationItem.title = kNavigationTitleNotificationList
        self.setBackButton()

        // table
        self.notificationTableView.delegate = self
        self.notificationTableView.estimatedRowHeight = 44
        self.notificationTableView.rowHeight = UITableViewAutomaticDimension
        self.notificationTableView.removeSeparatorsWhenUsingDefaultCell()
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.notificationTableView)
        self.notificationTableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.requestNotifications()
        }

        self.list.map { [unowned self] (notification:  Notification) -> NotificationTableViewCell in
            let cell = NotificationTableViewCell.getView("NotificationTableViewCell") as! NotificationTableViewCell
            notification.body ->> cell.notificationLabel.dynText
            map(notification.createdAt) { dateString in
                return DateHelper.getDateString(dateString)
            } ->> cell.dateLabel.dynText
            return cell
        } ->> self.tableViewDataSourceBond
        
        self.requestNotifications()
    }
    
    private func requestNotifications() {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.NotificationList(page: self.page)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list.append(box.value.notifications)

                // paging
                self.page++
                if box.value.meta.nextPage.value == 0 {
                    self.notificationTableView.showsInfiniteScrolling = false
                }

                // open api
                var ids = [Int]()
                for n in box.value.notifications {
                    ids.append(n.identifier.value)
                }
                ApiHelper.sharedInstance.call(ApiHelper.NotificationOpen(ids: ids)) { response in
                    //nothing to do
                }

                hideLoading()
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
                showError(message: kMessageCommonError)
            }
        }
    }

}
