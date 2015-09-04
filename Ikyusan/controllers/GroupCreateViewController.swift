import UIKit
import Bond

protocol GroupCreateViewControllerDelegate {
    func groupCreateViewControllerUpdated()
}

class GroupCreateViewController: BaseViewController {

    var group = Group()
    
    @IBOutlet weak var groupNameTextField: UITextField!

    @IBOutlet weak var countLabel: UILabel!

    @IBOutlet weak var colorListScrollView: UIScrollView!
    

    var delegate :GroupCreateViewControllerDelegate?
    
    init() {
        super.init(nibName: "GroupCreateViewController", bundle: nil)
    }

    init(inout group :Group) {
        super.init(nibName: "GroupCreateViewController", bundle: nil)
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
    
    private func setup() {
        
        self.navigationItem.title = kNavigationTitleGroupCreate
        
        self.view.backgroundColor = kBackgroundColor
        
        self.setEndEditWhenViewTapped()

        self.setCloseButton(nil)

        var groupColorListView = GroupColorListView.loadFromNib() as? GroupColorListView
        groupColorListView?.setupColors(self.group.colorCodeId.value)

        self.colorListScrollView.addSubview(groupColorListView!)
        self.colorListScrollView.contentSize.width = 648 // 12 * 44 + (12 - 1) * 8 + 16 * 2 // temp

        var buttonString = self.group.identifier.value == 0 ? "作成" : "更新"
        let doneButton = UIBarButtonItem().bk_initWithTitle(buttonString, style: UIBarButtonItemStyle.Plain) { (t) -> Void in

            showLoading()

            let name        = self.groupNameTextField.text
            let colorCodeId = groupColorListView?.currentColorCodeId

            // TODO: も少しDRYできる？？
            if self.group.identifier.value == 0 {
                ApiHelper.sharedInstance.call(ApiHelper.CreateGroup(name :name,
                    colorCodeId :colorCodeId!)) { response in
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
                ApiHelper.sharedInstance.call(ApiHelper.UpdateGroup(identifier: self.group.identifier.value,
                    name :name,
                    colorCodeId :colorCodeId!)) { response in
                    switch response {
                    case .Success(let box):
                        hideLoading()
                        println(box.value)
                        var group = box.value
                        self.group.name.value        = group.name.value
                        self.group.colorCodeId.value = group.colorCodeId.value
                        self.delegate!.groupCreateViewControllerUpdated()
                    case .Failure(let box):
                        hideLoading()
                        println(box.value) // NSError
                    }
                }
            }

        } as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = doneButton

        map(self.groupNameTextField.dynText) { text in
            // TODO: スペースのチェックいれる？
            return count(text) > 0 && count(text) <= 20
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

        self.group.name ->> self.groupNameTextField.dynText
    }

}
