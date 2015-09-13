import UIKit
import Bond

protocol InviteViewControllerDelegate {
    func inviteViewControllerCompleted(invite :Invite)
}

class InviteViewController: BaseViewController {

    var groupId = 0

    var delegate :InviteViewControllerDelegate?

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(groupId :Int) {
        super.init(nibName: "InviteViewController", bundle: nil)
        self.groupId = groupId
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setup() {
        self.navigationItem.title = kNavigationDoInvite
        setEndEditWhenViewTapped()

        map(self.idTextField.dynText) { text in
            return count(text) > 0
        } ->> self.inviteButton.dynEnabled
    }

    @IBAction func inviteButtonTapped(sender: AnyObject) {
        if self.idTextField.text.isEmpty {
            return
        }

        showLoading()
        self.idTextField.resignFirstResponder()

        ApiHelper.sharedInstance.call(ApiHelper.InviteGroup(groupId: self.groupId, targetDisplayId: self.idTextField.text)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                hideLoading()
                ToastHelper.make(self.view, message: "招待しました!!")
                self.idTextField.text = ""
                self.delegate?.inviteViewControllerCompleted(box.value)
            case .Failure(let box):
                println(box.value)
                hideLoading()
                ToastHelper.make(self.view, message: "存在しないIDです") // TODO: このエラーメッセージに統一しちゃって大丈夫？？
            }
        }
    }

}
