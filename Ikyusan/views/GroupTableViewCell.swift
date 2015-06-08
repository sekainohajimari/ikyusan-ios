import UIKit
import SWTableViewCell

class GroupTableViewCell: SWTableViewCell {

    var group :Group?
    
    func setData(group :Group) {
        self.group = group
        if let name = group.name {
            self.textLabel!.text = name
        }
    }

}
