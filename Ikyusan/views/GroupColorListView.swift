import UIKit

protocol GroupColorListViewDelegate {
    func groupColorListViewSelected(color :GroupColor)
}

class GroupColorListView: UIView {

    var delegate :GroupColorListViewDelegate?

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
                (v as! UIView).layer.borderColor = UIColor.blueColor().CGColor
                (v as! UIView).layer.borderWidth = 2
            } else {
                (v as! UIView).layer.borderColor = UIColor.blueColor().CGColor
                (v as! UIView).layer.borderWidth = 0
            }
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        // TODO:enum揃えるまで一旦コメントアウト
        self.setSelectionBorder(sender.tag)
        self.delegate?.groupColorListViewSelected(GroupColor(rawValue: sender.tag)!)
    }
}
