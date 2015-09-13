import UIKit
import BlocksKit
import CSNNotificationObserver

class BaseViewController: UIViewController,
    UIGestureRecognizerDelegate {

    let observer = CSNNotificationObserver()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }

    func setCloseButton(completion :(() -> Void)?) {
        let image = UIImage(named: "icon_close")
        let closeButton = UIBarButtonItem().bk_initWithImage(image, style: UIBarButtonItemStyle.Plain) { (t) -> Void in
            self.dismissViewControllerAnimated(true, completion: completion)
        } as! UIBarButtonItem
        self.navigationItem.leftBarButtonItems = [closeButton]
    }
    
    func setEndEditWhenViewTapped() {
        let tap = UITapGestureRecognizer().bk_initWithHandler { (r, s, p) -> Void in
            self.view.endEditing(true)
        } as! UITapGestureRecognizer
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
}
