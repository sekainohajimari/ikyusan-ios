import UIKit

protocol AvatarSettingTableViewCellDelegate {
    func avatarSettingTapped()
}

class AvatarSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarButton: UIButton!

    var delegate :AvatarSettingTableViewCellDelegate?

    var inUseDefaultIcon = false

    override func awakeFromNib() {
        super.awakeFromNib()

        self.avatarButton.layer.cornerRadius = self.avatarButton.getWidth() / 2
        self.avatarButton.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func applyAvatarImage(image :UIImage) {
        self.avatarButton.setImage(image, forState: UIControlState.Normal)
    }

    func applyDefaultImage(image :UIImage) {
        self.avatarButton.setImage(image, forState: UIControlState.Selected)
    }

    func useDefaultIcon(bool :Bool) {
        self.inUseDefaultIcon = bool
        self.avatarButton.selected = bool
    }

    @IBAction func tapped(sender: AnyObject) {
        self.avatarButton.selected = !self.avatarButton.selected
        self.delegate?.avatarSettingTapped()
    }


}
