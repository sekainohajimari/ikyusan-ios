import UIKit
import Bond

protocol GroupCreateViewControllerDelegate {
    func groupCreateViewControllerUpdated()
}

class GroupCreateViewController: BaseViewController {

    var group = Group()
    
    @IBOutlet weak var groupNameTextField:  UITextField!
    @IBOutlet weak var countLabel:          UILabel!
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
        self.setCloseButton(nil)
        
        self.view.backgroundColor = kBackgroundColor
        self.setEndEditWhenViewTapped()

        let groupColorListView = GroupColorListView.getView("GroupColorListView") as! GroupColorListView
        groupColorListView.setupColors(self.group.colorCodeId.value)

        self.colorListScrollView.addSubview(groupColorListView)
        self.colorListScrollView.contentSize.width = 648 // 12 * 44 + (12 - 1) * 8 + 16 * 2 ダサい・・・

        let buttonString = self.group.identifier.value == 0 ? "作成" : "更新"
        let doneButton = UIBarButtonItem().bk_initWithTitle(buttonString, style: UIBarButtonItemStyle.Plain) { (t) -> Void in

            let name        = self.groupNameTextField.text
            let colorCodeId = groupColorListView.currentColorCodeId

            showLoading()
            // TODO: も少しDRYできる？？
            if self.group.identifier.value == 0 {
                ApiHelper.sharedInstance.call(ApiHelper.CreateGroup(
                    name :name!,
                    colorCodeId :colorCodeId)) { response in
                    switch response {
                    case .Success(let box):
                        hideLoading()
                        pri(box.value)
                        self.delegate!.groupCreateViewControllerUpdated()
                    case .Failure(let box):
                        hideLoading()
                        pri(box.value)
                        showError(kMessageCommonError)
                    }
                }
            } else {
                ApiHelper.sharedInstance.call(ApiHelper.UpdateGroup(
                    identifier: self.group.identifier.value,
                    name :name!,
                    colorCodeId :colorCodeId)) { response in
                    switch response {
                    case .Success(let box):
                        hideLoading()
                        pri(box.value)

                        // memo: ユーザビリティ的にどうかわからないけど、TOPに飛ばしてしまう・・・
                        let notification = NSNotification(name: kNotificationGroupChange, object: nil)
                        NSNotificationCenter.defaultCenter().postNotification(notification)
                        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

                    case .Failure(let box):
                        hideLoading()
                        pri(box.value)
                        showError(kMessageCommonError)
                    }
                }
            }

        } as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = doneButton

        self.groupNameTextField.bnd_text.map { text in
            // TODO: スペースのチェックいれる？
            return text!.characters.count > 0 && text!.characters.count <= 20
        } ->> doneButton.bnd_enabled

        self.groupNameTextField.bnd_text.map { text in
            return String(text!.characters.count) + "/20"
        } ->> self.countLabel.bnd_text

        self.groupNameTextField.bnd_text.map { text in
            if text!.characters.count > 20 {
                return UIColor.redColor()
            }
            return kBaseBlackColor
        }.bindTo(self.countLabel.bnd_textColor)

        self.group.name.bindTo(self.groupNameTextField.bnd_text)
    }

}
