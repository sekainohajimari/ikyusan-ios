import UIKit
import Bond

protocol GroupCreateViewControllerDelegate {
    func groupCreateViewControllerUpdated()
}

class GroupCreateViewController: BaseViewController, GroupColorListViewDelegate {

    var group = Group()

    var isUpdate = false // 少し設計ミスだけど、この画面は新規作成と更新の両方を兼ねてる。その判定フラグ
    
    @IBOutlet weak var groupNameTextField: UITextField!

    @IBOutlet weak var countLabel: UILabel!

    @IBOutlet weak var colorListScrollView: UIScrollView!
    

    var delegate :GroupCreateViewControllerDelegate?
    
    init() {
        super.init(nibName: "GroupCreateViewController", bundle: nil)
    }

    init(group :Group) {
        super.init(nibName: "GroupCreateViewController", bundle: nil)
        self.group = group
        self.isUpdate = true
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

        var groupColorListView = GroupColorListView.loadFromNib() as? GroupColorListView
        groupColorListView?.setupColors(self.group.colorCodeId.value)
        groupColorListView?.delegate = self

        self.colorListScrollView.addSubview(groupColorListView!)
        self.colorListScrollView.contentSize.width = 12 * 44 + (12 - 1) * 8 // temp
        
        let doneButton = UIBarButtonItem().bk_initWithBarButtonSystemItem(UIBarButtonSystemItem.Done,
            handler:{ (t) -> Void in

                if !self.validate() {
                    showError(message: "グループ名は1文字以上20文字以内です")
                    return
                }

                showLoading()

                // TODO: も少しDRYできる？？
                if !self.isUpdate {
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
                } else {
                    ApiHelper.sharedInstance.call(ApiHelper.UpdateGroup(group: self.group)) { response in
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

        self.group.name <->> self.groupNameTextField.dynText
    }
    
    private func validate() -> Bool {
        
        // TODO:spaceのみかどうかのチェックを入れる？
        
        if count(groupNameTextField.text) == 0 ||
            count(groupNameTextField.text) > 20 {
            return false
        }
        
        return true
    }

    // MARK: - GroupColorListViewDelegate

    func groupColorListViewSelected(color: GroupColor) {
        self.group.colorCodeId.value = color.rawValue
    }

}
