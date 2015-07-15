import UIKit

protocol GroupColorListViewDelegate {
    func groupColorListViewSelected(color :GroupColor)
}

// temp 多分別のしかるべき場所に定義する
enum GroupColor :Int {
    case YELLOW = 0
    case RED    = 1
    case BLUE   = 2
    case GREEN  = 3
    case GREY   = 4
}

class GroupColorListView: UIView {

    var delegate :GroupColorListViewDelegate?

    class func loadFromNib() -> AnyObject {
        var nib = UINib(nibName: "GroupColorListView", bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil)[0]
    }

    // TODO: initializeと同時に呼べない？？
    func setupColors() {
        for v in self.subviews {
            (v as! UIView).backgroundColor = UIColor.blackColor()
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        // TODO:enum揃えるまで一旦コメントアウト
//        self.delegate?.groupColorListViewSelected(GroupColor(rawValue: sender.tag)!)
    }
}
