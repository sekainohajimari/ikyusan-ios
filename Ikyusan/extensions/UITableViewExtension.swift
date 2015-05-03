import Foundation
import UIKit

extension UITableView {
    
    func removeSeparatorsWhenUsingDefaultCell() {
        var v:UIView = UIView(frame: CGRectZero)
        v.backgroundColor = UIColor.clearColor()
        self.tableFooterView = v
        self.tableHeaderView = v
    }
}