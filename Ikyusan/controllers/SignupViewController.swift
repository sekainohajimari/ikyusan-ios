import UIKit

protocol SignupViewControllerDelegate {
    func signupCompleted()
}

class SignupViewController: UIViewController,
    TwitterAuthViewDelegate {

    var delegate :SignupViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
