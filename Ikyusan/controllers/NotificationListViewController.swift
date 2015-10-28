import UIKit
import BlocksKit
import ObjectMapper
import Bond
import SVPullToRefresh

class NotificationListViewController: BaseViewController,
    UITableViewDelegate {

    @IBOutlet weak var notificationTableView: UITableView!

    var page = 1
    var list = ObservableArray<Notification>([])
    
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
        self.notificationTableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.requestNotifications()
        }

        self.list.lift().bindTo(self.notificationTableView) { (indexPath, array, tableView) -> UITableViewCell in
            let cell = NotificationTableViewCell.getView("NotificationTableViewCell") as! NotificationTableViewCell
            let data = array[0][indexPath.row]
            data.body.bindTo(cell.notificationLabel.bnd_text)
            data.createdAt.map { (dateString) -> String in
                return DateHelper.getDateString(dateString)
            }.bindTo(cell.dateLabel.bnd_text)
            return cell
        }

        self.requestNotifications()
    }
    
    private func requestNotifications() {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.NotificationList(page: self.page)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.list.extend(box.value.notifications)
                self.notificationTableView.infiniteScrollingView.stopAnimating()

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
                pri(box.value) // NSError
                hideLoading()
                showError(kMessageCommonError)
            }
        }
    }

}
