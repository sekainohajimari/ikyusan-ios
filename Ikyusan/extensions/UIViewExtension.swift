import UIKit

extension UIView {
    
    func setX(x:CGFloat) {
        self.frame.origin.x = x
    }
    
    func setY(y:CGFloat) {
        self.frame.origin.y = y
    }
    
    func setWidth(width:CGFloat) {
        self.frame.size.width = width
    }
    
    func setHeight(height:CGFloat) {
        self.frame.size.height = height
    }
    
    func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func getWidth() -> CGFloat {
        return self.frame.size.width
    }
    
    func getHeight() -> CGFloat {
        return self.frame.size.height
    }

    func setCornerRadius(radius :CGFloat = 5) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    class func getView(nibName :String) -> UIView {
        var nib = UINib(nibName: nibName, bundle: nil)
        var views = nib.instantiateWithOwner(self, options: nil)
        return views[0] as! UIView
    }
}