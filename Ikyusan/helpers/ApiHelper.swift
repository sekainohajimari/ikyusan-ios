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
                handler(Response(a!))
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
        var path = "/g"  // /api/v1/g/:id/edit(.:format)
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = Group
        
        init(group :Group) {
            
            if let name = group.name {
                self.params = ["name" : name]
            }
            
            if let identifier = group.identifier {
                self.path = self.path + "/" + String(identifier) + "/edit"
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
        let method = "POST"
        let path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        var group :Group?
        
        typealias Response = Group
        
        init(group :Group) {
            self.group = group
            
            //paramsに変換
            
            //pathもいじる
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
        let path = "/g"
        let tokenCheck = true
        var params : Dictionary<String, NSObject>?
        
        typealias Response = [Like]
        
        func convertJSONObject(object: AnyObject) -> Response? {
            var likeList: [Like]?
            
            if let dictionary = object as? NSDictionary {
                likeList = Mapper<Like>().mapArray(dictionary["like"])
            }
            
            return likeList
        }
    }
    
    /** 一休さんに訊こう */
    
    
    /** プロフィール編集 */
    
    
}





// APIの戻りの書き方、ジェネリック用いたものでやってみる
//class ApiHelper: NSObject {
//    
//    private let kBaseUrl = "http://ikyusan.sekahama.club/api/v1/"
//    
//    //singleton
//    class var sharedInstance : ApiHelper {
//        struct Static {
//            static let instance : ApiHelper = ApiHelper()
//        }
//        return Static.instance
//    }
//    
//    override init() {
//        super.init()
//        
////        self.requestSerializer.HTTPShouldHandleCookies = false
////        self.requestSerializer.setValue("ios-fan", forHTTPHeaderField: "X-Note-Device")
////        self.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//   
//    /** サインイン(Twitter, Facebook) */
//    
//    /** サインアウト */
//    
//    /** グループ作成 */
//    func createGroup(groupName :String,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//            
//            //islogin check
//            
//            let URL = NSURL(string: kBaseUrl + "g")!
//            let mutableURLRequest = NSMutableURLRequest(URL: URL)
//            mutableURLRequest.HTTPMethod = "POST"
//            
//            let parameters = ["name": groupName]
//            var JSONSerializationError: NSError? = nil
//            mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
//            mutableURLRequest.setValue("86e1e457b6ee884c19d3674f09be30b382b8ac6587f9f110dbc1e1472be4b65dceed995248410ee4", forHTTPHeaderField: "token")
//            
//            let request = Alamofire.request(mutableURLRequest)
//            request.response { (request, response, result, error) -> Void in
//                if error != nil {
//                    println("Error")
//                } else {
//                    println("Successful")
//                    println("%@", request)
//                    println("%@", response)
//                }
//            }
//            
//            return
//    }
//    
//    /** グループ編集 */
//    func updateGroup(groupName :String,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//            
//    }
//    
//    /** グループ一覧取得 */
//    func getGroups(block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//        //islogin check
//        
//        let URL = NSURL(string: kBaseUrl + "g")!
//        let mutableURLRequest = NSMutableURLRequest(URL: URL)
//        mutableURLRequest.HTTPMethod = "GET"
//        
//        var JSONSerializationError: NSError? = nil
//        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject([], options: nil, error: &JSONSerializationError)
//        mutableURLRequest.setValue("86e1e457b6ee884c19d3674f09be30b382b8ac6587f9f110dbc1e1472be4b65dceed995248410ee4", forHTTPHeaderField: "token")
//        
//        let request = Alamofire.request(mutableURLRequest)
//        request.response { (request, response, result, error) -> Void in
//            if error != nil {
//                println("Error")
//            } else {
//                println("Successful")
//                println("%@", request)
//                println("%@", response)
//            }
//        }
//        
//        return
//        
////        var json :Array<[String : AnyObject]> = [
////            [
////                "id" : 1,
////                "name" : "sekai no hajimari"
////            ],
////            [
////                "id" : 2,
////                "name" : "POC"
////            ]
////        ]
////        return block(result: json, error: nil)
//    }
//    
//    /** グループへの招待 */
//    func createInvite(userName :String,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        //
//    }
//    
//    /** トピック作成 */
//    func createTopic(topicName :String,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//    }
//    
//    /** トピック編集 */
//    func updateTopic(topicName :String,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//    }
//    
//    /** トピック一覧取得 */
//    func getTopics(groupId :Int,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        var json :Array<[String : AnyObject]> = [
//            [
//                "id" : 1,
//                "name" : "トーク内容"
//            ],
//            [
//                "id" : 2,
//                "name" : "呼びたいゲスト"
//            ],
//            [
//                "id" : 3,
//                "name" : "食べ歩きもやりたいYo!"
//            ]
//        ]
//        return block(result: json, error: nil)
//    }
//    
//    /** ネタ作成 */
//    func createIdea(content :String, anonymity :Bool,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//    }
//    
//    /** ネタ削除 */
//    func deleteIdea(ideaId :Int,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//    }
//    
//    /** ネタ一覧取得 */
//    func getIdeas(topidId :Int, block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        var json :Array<[String : AnyObject]> = [
//            [
//                "id" : 1,
//                "content" : "タコベル食レポ",
//                "like_count" : 1,
//                "created_at" : "2015-05-02 10:01:33"
//            ],
//            [
//                "id" : 2,
//                "content" : "須川さんに聞く、今年は何人の男と付き合うのか",
//                "like_count" : 13,
//                "created_at" : "2015-05-01 10:01:33"
//            ],
//            [
//                "id" : 3,
//                "content" : "夏休みの児童向け　俺が考えた怖い話スペシャルーーー　脱稲川淳二 いけいけGOGO7188 メリーゴーランド",
//                "like_count" : 3,
//                "created_at" : "2015-04-14 10:01:33"
//            ]
//        ]
//        return block(result: json, error: nil)
//    }
//    /** イイね */
//    func createLike(ideaId :Int,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        
//    }
//    
//    /** イイね一覧 */
//    func getLikes(ideaId :Int,
//        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
//        //
//    }
//    
//    /** 一休さんに訊こう */
//    func getIdeaFromIkyusan() {
//        
//    }
//    
//    /** プロフィール編集 */
//    func updateAccount() {
//        
//    }
//}
