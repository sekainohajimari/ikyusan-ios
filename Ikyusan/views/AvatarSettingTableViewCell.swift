import UIKit

protocol AvatarSettingTableViewCellDelegate {
    func avatarSettingTapped()
}

class AvatarSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarButton: UIButton!

    var delegate :AvatarSettingTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.avatarButton.layer.cornerRadius = self.avatarButton.getWidth() / 2
        self.avatarButton.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setAvatarImage(image :UIImage) {
        self.avatarButton.setImage(image, forState: UIControlState.Normal)
    }

    @IBAction func tapped(sender: AnyObject) {
        self.avatarButton.selected = !self.avatarButton.selected
        self.delegate?.avatarSettingTapped()
    }


}
