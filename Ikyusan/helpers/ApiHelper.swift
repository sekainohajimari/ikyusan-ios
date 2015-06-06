import UIKit
import Alamofire
import ObjectMapper


// ref : https://github.com/ishkawa/sandbox/blob/master/SwiftAPIClient/WebAPI/GitHub.swift
// 理解すること！！


class Box<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

protocol Request {
    var method          : String { get }
    var path            : String { get }
    var params          : Dictionary<String, NSObject>? { get }
    var tokenCheck      : Bool { get }
    
    typealias Response: Any
    
    func convertJSONObject(object: AnyObject) -> Response?
}

enum Response<T> {
    case Success(Box<T>)
    case Failure(Box<NSError>)
    
    init(_ value: T) {
        self = .Success(Box(value))
    }
    
    init(_ error: NSError) {
        self = .Failure(Box(error))
    }
}

class ApiHelper {
    
    class var sharedInstance : ApiHelper {
        struct Static {
            static let instance : ApiHelper = ApiHelper()
        }
        return Static.instance
    }

    let kBaseUrl = "http://ikyusan.sekahama.club/api/v1/"
    
    func call<T: Request>(request: T, handler: (Response<T.Response>) -> Void = { r in }) {
        
        let URL = NSURL(string: kBaseUrl + request.path)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = request.method

        var JSONSerializationError: NSError? = nil
        
        if let params = request.params {
            mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &JSONSerializationError)
        }
        if request.tokenCheck {
            mutableURLRequest.setValue("Token token=\"d6ad5c61da3e28b3302c44c082ef878abe195c27269f2b04f4723625950f5b1d2cb3020dd8df740a\"", forHTTPHeaderField: "Authorization")
        }
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let alamofireRequest = Alamofire.request(mutableURLRequest)
//                                        .validate(statusCode: 200..<300)
                                        .validate(contentType: ["application/json"])
                                        .responseJSON { (req, res, result, error) -> Void in

            if let e = error {
                println("Error")
                handler(Response(e))
            } else {
                println("Successful")
                println("%@", request)
                println("%@", result)
                
                var a = request.convertJSONObject(result!)
                if a != nil { //temp code
                    handler(Response(a!))
                }
            }
        }
    }
}

extension ApiHelper {
    
    /** グループ一覧取得 */
    class GroupList: Request {
        let method = "GET"
        let path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = [Group]
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var groupList: [Group]?
            
            if let dictionary = object as? NSDictionary {
                groupList = Mapper<Group>().mapArray(dictionary["groups"])
            }
            
            return groupList
        }
    }
    
    /** グループ作成 */
    class CreateGroup: Request {
        let method = "POST"
        let path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Group
        
        init(params :Dictionary<String, NSObject>) {
            self.params = params
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var group: Group?
            
            if let dictionary = object as? NSDictionary {
                group = Mapper<Group>().map(dictionary["group"])
            }
            
            return group
        }
    }
    
    
    /** グループ編集 */
    class UpdateGroup: Request {
        let method = "GET"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Group
        
        init(group :Group) {
            if let identifier = group.identifier {
                self.path += "/" + String(identifier) + "/edit?name=" + group.name!.urlEncode()!
            }
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var group: Group?
            
            if let dictionary = object as? NSDictionary {
                group = Mapper<Group>().map(dictionary["group"])
            }
            
            return group
        }
    }
    
    /** グループへの招待 */
    class InviteGroup: Request {
        let method = "POST"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Group
        
        init(groupId :Int, targetDisplayId :String) {
            self.path += "/" + String(groupId) + "/invite/doing/" + String(targetDisplayId)
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var group: Group?
            
            if let dictionary = object as? NSDictionary {
                group = Mapper<Group>().map(dictionary["group"])
            }
            
            return group
        }
    }
    
    /** トピック作成 */
    class CreateTopic: Request {
        let method = "POST"
        var path = "/g" // /api/v1/g/:group_id/t(.:format)
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Topic
        
        init(groupId :Int, name :String) {
            self.path += "/" + String(groupId) + "/t"
            self.params = ["name" : name]
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var topic: Topic?
            
            if let dictionary = object as? NSDictionary {
                topic = Mapper<Topic>().map(dictionary["topic"])
            }
            
            return topic
        }
    }
    
    /** トピック編集 */
    class UpdateTopic: Request {
        let method = "GET" ///api/v1/g/:group_id/t/:id/edit(.:format)
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Group
        
        init(groupId :Int, topicId :Int, name :String) {
            self.path += "/" + String(groupId) + "/t/" + String(topicId) + "/edit?name=" + name
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var group: Group?
            
            if let dictionary = object as? NSDictionary {
                group = Mapper<Group>().map(dictionary["group"])
            }
            
            return group
        }
    }
    
    /** トピック一覧取得 */
    class TopicList: Request {
        let method = "GET"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = [Topic]
        
        init(groupId :Int) {
            self.path += "/" + String(groupId) + "/t"
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var topicList: [Topic]?
            
            if let dictionary = object as? NSDictionary {
                topicList = Mapper<Topic>().mapArray(dictionary["topics"])
            }
            
            if topicList == nil {
                topicList = []
            }
            
            return topicList
        }
    }
    
    /** ネタ作成 */
    class CreateIdea: Request {
        let method = "POST"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Idea
        
        init(groupId :Int, topicId :Int, content :String) {
            self.path += "/" + String(groupId) + "/t/" + String(topicId) + "/i"
            self.params = ["content" : content]
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var idea: Idea?
            
            if let dictionary = object as? NSDictionary {
                idea = Mapper<Idea>().map(dictionary["idea"])
            }
            
            return idea
        }
    }
    
    /** ネタ削除 */
    class DeleteIdea: Request {
        let method = "POST"
        let path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Idea
        
        init(params :Dictionary<String, NSObject>) {
            self.params = params
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var idea: Idea?
            
            if let dictionary = object as? NSDictionary {
                idea = Mapper<Idea>().map(dictionary["idea"])
            }
            
            return idea
        }
    }
    
    /** ネタ一覧取得 */
    class IdeaList: Request {
        let method = "GET"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = [Idea]
        
        init(groupId :Int, topicId :Int) {
            self.path += "/" + String(groupId) + "/t/" + String(topicId) + "/i"
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var ideaList: [Idea]?
            
            if let dictionary = object as? NSDictionary {
                ideaList = Mapper<Idea>().mapArray(dictionary["ideas"])
            }
            
            return ideaList
        }
    }
    
    /** イイね */
    class CreateLike: Request {
        let method = "POST"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Idea
        
        init(groupId :Int, topicId :Int, ideaId :Int, num :Int) {
            self.path += "/" + String(groupId) + "/t/" + String(topicId) + "/i/" + String(ideaId) + "/l/doing"
            self.params = ["num" : num]
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var idea: Idea?
            
//            if let dictionary = object as? NSDictionary {
//                idea = Mapper<Idea>().map(dictionary["idea"])
//            }
            
            return idea
        }
    }
    
    /** イイね一覧 */
    class LikeList: Request {
        let method = "GET"
        var path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = [Like]
        
        init(groupId :Int, topicId :Int, ideaId :Int) {
            self.path += "/" + String(groupId) + "/t/" + String(topicId) + "/i/" + String(ideaId) + "/l"
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var likeList: [Like]?
            
            if let dictionary = object as? NSDictionary {
                likeList = Mapper<Like>().mapArray(dictionary["like"])
            } else {
                likeList = []
            }
            
            return likeList
        }
    }
    
    /** お知らせ一覧 */
    class NotificationList: Request {
        let method = "GET"
        var path = "/notifications"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = [Notification]
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var notificationList: [Notification]?
            
            if let dictionary = object as? NSDictionary {
                notificationList = Mapper<Notification>().mapArray(dictionary["notification_messages"])
            } else {
                notificationList = []
            }
            
            return notificationList
        }
    }
    
    /** 一休さんに訊こう */
    
    
    /** プロフィール編集 */
    class ProfileEdit: Request {
        let method = "GET"
        var path = "/profile"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Profile
        
        init(userId :Int) {
            self.path += "/" + String(userId) + "/edit"
        }
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var profile: Profile?
            
            if let dictionary = object as? NSDictionary {
                profile = Mapper<Profile>().map(dictionary["profile"])
            }
            
            return profile
        }
    }
    
    
    /** プロフィール取得 */
    class ProfileInfo: Request {
        let method = "GET"
        var path = "/profile"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Profile
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var profile: Profile?
            
            if let dictionary = object as? NSDictionary {
                profile = Mapper<Profile>().map(dictionary)
            }
            
            return profile
        }
    }
    
}
