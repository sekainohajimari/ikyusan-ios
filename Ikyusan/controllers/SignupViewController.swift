import UIKit

protocol SignupViewControllerDelegate {
    func signupCompleted()
}

class SignupViewController: BaseViewController,
    TwitterAuthViewDelegate {

    var delegate :SignupViewControllerDelegate?

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
        self.navigationItem.title = kNavigationTitleRegistration
        setBackButton()
    }

    // MARK: - IB action


    @IBAction func accountCreateButtonTapped(sender: AnyObject) {
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let token = (uuid + SignupHelper.getSignupToken()).toMD5()
        ApiHelper.sharedInstance.call(ApiHelper.SignupWithUUID(uuid: uuid, token: token), handler: { [unowned self] response in
            self.navigationController?.dismissViewControllerAnimated(true,
                completion: { () -> Void in
                    self.delegate?.signupCompleted()
                })
        })
    }

    @IBAction func twitterSignupButtonTapped(sender: AnyObject) {
        var vc = TwitterAuthViewController(nibName: "TwitterAuthViewController", bundle: nil)
        vc.delegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - TwitterAuthViewDelegate

    func twitterAuthCompleted() {
        self.navigationController?.dismissViewControllerAnimated(true,
            completion: { [unowned self] () -> Void in
            self.delegate?.signupCompleted()
        })
    }
}
