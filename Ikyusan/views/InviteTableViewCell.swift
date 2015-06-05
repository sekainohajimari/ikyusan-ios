import UIKit

protocol InviteTableViewCellDelegate {
    func inviteTableViewCellInviteButtonTapped(name :String)
}

class InviteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!
    
    var delegate :InviteTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func inviteButtonTapped(sender: AnyObject) {
        accountTextField.resignFirstResponder() // TODO:動く？？
        if !self.validate() {
            showError()
            return
        }
        var name = accountTextField.text!
        accountTextField.text = ""
        
        self.delegate!.inviteTableViewCellInviteButtonTapped(name)
    }
    
    private func validate() -> Bool {
        return true
    }
    
}
