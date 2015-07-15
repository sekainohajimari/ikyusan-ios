import UIKit
import SWTableViewCell

class TopicTableViewCell: SWTableViewCell {

    var topic :Topic?
    
    func setData(topic :Topic) {
        self.topic = topic
        self.textLabel!.text = topic.name.value
    }

}
