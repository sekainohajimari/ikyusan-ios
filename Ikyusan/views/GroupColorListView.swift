import UIKit

// TODO: 動的生成にすること!!!
class GroupColorListView: UIView {

    var currentColorCodeId = GroupColor.Red.rawValue

    func setupColors(_ colorCodeId :Int = GroupColor.Red.rawValue) {
        self.currentColorCodeId = colorCodeId
        for v in self.subviews {
            let view = v as! UIView
            let tag  = view.tag
            view.backgroundColor     = GroupColor(rawValue: tag)?.getColor()
            view.layer.cornerRadius  = view.getWidth() / 2
            view.layer.masksToBounds = true
        }
        self.setSelectionBorder(colorCodeId)
    }

    private func setSelectionBorder(selectedTag :Int) {
        for v in self.subviews {
            let view = v as! UIView
            let tag  = view.tag
            view.layer.borderColor = UIColor.darkGrayColor().CGColor
            // TODO: デザイン変えたい
            if tag == selectedTag {
                view.layer.borderWidth = 4
            } else {
                view.layer.borderWidth = 0
            }
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        let tag = sender.tag
        self.setSelectionBorder(tag)
        self.currentColorCodeId = tag
    }
}
