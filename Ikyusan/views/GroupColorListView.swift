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
            // TODO: デザイン変えたい
            if tag == selectedTag {
                view.layer.borderColor = view.backgroundColor?.CGColor
                view.layer.borderWidth = 5
            } else {
                view.layer.borderColor = UIColor.whiteColor().CGColor
                view.layer.borderWidth = 5
            }
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        let tag = sender.tag
        self.setSelectionBorder(tag)
        self.currentColorCodeId = tag
    }
}
