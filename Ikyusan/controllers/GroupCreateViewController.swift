import UIKit
import Bond

protocol GroupCreateViewControllerDelegate {
    func groupCreateViewControllerUpdated()
}

class GroupCreateViewController: BaseViewController, GroupColorListViewDelegate {

    var group = Group()
    
    @IBOutlet weak var groupNameTextField: UITextField!

    @IBOutlet weak var countLabel: UILabel!

    @IBOutlet weak var colorListScrollView: UIScrollView!
    

    var delegate :GroupCreateViewControllerDelegate?
    
    init() {
        super.init(nibName: "GroupCreateViewController", bundle: nil)
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
    
    private func setup() {
        
        self.navigationItem.title = kNavigationTitleGroupCreate
        
        self.view.backgroundColor = kBackgroundColor
        
        self.setEndEditWhenViewTapped()

        self.setCloseButton(nil)

        self.group.colorCodeId.value = GroupColor.Black.rawValue

        var groupColorListView = GroupColorListView.loadFromNib() as? GroupColorListView
        groupColorListView?.setupColors()
        groupColorListView?.delegate = self
        self.colorListScrollView.addSubview(groupColorListView!)
        self.colorListScrollView.contentSize.width = 512 // temp
        
        let doneButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Done,
            handler:{ (t) -> Void in
                if !self.validate() {
                    showError(message: "グループ名は1文字以上20文字以内です")
                    return
                }

                showLoading()
                ApiHelper.sharedInstance.call(ApiHelper.CreateGroup(group: self.group)) { response in
                    switch response {
                    case .Success(let box):
                        hideLoading()
                        println(box.value)
                        self.delegate!.groupCreateViewControllerUpdated()
                    case .Failure(let box):
                        hideLoading()
                        println(box.value) // NSError
                    }
                }
                
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = doneButton

        map(self.groupNameTextField.dynText) { text in
            return count(text) > 0
        } ->> doneButton.dynEnabled

        map(self.groupNameTextField.dynText) { text in
            return String(count(text)) + "/20"
        } ->> self.countLabel.dynText

        map(self.groupNameTextField.dynText) { text in
            if count(text) > 20 {
                return UIColor.redColor()
            }
            return UIColor.darkGrayColor()
        } ->> self.countLabel.dynTextColor

        self.groupNameTextField.dynText ->> self.group.name
    }
    
    private func validate() -> Bool {
        
        // TODO:spaceのみかどうかのチェックを入れる？
        
        if count(groupNameTextField.text) == 0 ||
            count(groupNameTextField.text) > 20 {
            return false
        }
        
        return true
    }

    // MARK: - IB action

    @IBAction func inviteButtonTapped(sender: AnyObject) {
        //
    }

    // MARK: - GroupColorListViewDelegate

    func groupColorListViewSelected(color: GroupColor) {
//        self.group.colr = color.rawValue
    }

}
