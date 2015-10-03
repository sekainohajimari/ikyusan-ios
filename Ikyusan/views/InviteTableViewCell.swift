import UIKit

protocol InviteTableViewCellDelegate {
    func inviteTableViewCellInviteButtonTapped(name :String)
}

class InviteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!
    
    var delegate :InviteTableViewCellDelegate?
    
    @IBAction func inviteButtonTapped(sender: AnyObject) {
        accountTextField.resignFirstResponder()
        var name = accountTextField.text!
        accountTextField.text = ""
        self.delegate!.inviteTableViewCellInviteButtonTapped(name)
    }
    
}
