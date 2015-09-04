import UIKit


class GroupColorListView: UIView {

    var currentColorCodeId = GroupColor.Red.rawValue

    class func loadFromNib() -> AnyObject {
        var nib = UINib(nibName: "GroupColorListView", bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil)[0]
    }

    // TODO: initializeと同時に呼べない？？
    func setupColors(_ colorCodeId :Int = GroupColor.Red.rawValue) {
        for v in self.subviews {
            var tag = (v as! UIView).tag
            print(tag)
            (v as! UIView).backgroundColor = GroupColor(rawValue: tag)?.getColor()

            (v as! UIView).layer.cornerRadius  = (v as! UIView).getWidth() / 2
            v.layer.masksToBounds = true
        }

        self.setSelectionBorder(colorCodeId)
    }

    private func setSelectionBorder(selectedTag :Int) {
        for v in self.subviews {
            var tag = (v as! UIView).tag
            if tag == selectedTag {
                (v as! UIView).layer.borderColor = UIColor.darkGrayColor().CGColor
                (v as! UIView).layer.borderWidth = 4
            } else {
                (v as! UIView).layer.borderColor = UIColor.darkGrayColor().CGColor
                (v as! UIView).layer.borderWidth = 0
            }
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        self.setSelectionBorder(sender.tag)
        currentColorCodeId = sender.tag
    }
}
