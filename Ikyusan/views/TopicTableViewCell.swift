import UIKit
import SWTableViewCell

class TopicTableViewCell: SWTableViewCell {

    var topic :Topic?
    
    func setData(topic :Topic) {
        self.topic = topic
        if let name = topic.name {
            self.textLabel!.text = name
        }
    }

}
