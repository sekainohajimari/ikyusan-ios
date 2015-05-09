//
//  ApiHelper.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Alamofire

// APIの戻りの書き方、ジェネリック用いたものでやってみる
class ApiHelper: NSObject {
    
    static var kBaseUrl = "https://sekainohajimari.mu/api/v1"
    
    //singleton
    class var sharedInstance : ApiHelper {
        struct Static {
            static let instance : ApiHelper = ApiHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
//        self.requestSerializer.HTTPShouldHandleCookies = false
//        self.requestSerializer.setValue("ios-fan", forHTTPHeaderField: "X-Note-Device")
//        self.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    /** サインイン(Twitter, Facebook) */
    
    /** サインアウト */
    
    /** グループ作成 */
    func createGroup(groupName :String,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        //
    }
    
    /** グループ編集 */
    func updateGroup(groupName :String,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        //
    }
    
    /** グループ一覧取得 */
    func getGroups(block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        var json :Array<[String : AnyObject]> = [
            [
                "id" : 1,
                "name" : "sekai no hajimari"
            ],
            [
                "id" : 2,
                "name" : "POC"
            ]
        ]
        return block(result: json, error: nil)
    }
    
    /** グループへの招待 */
    func createInvite(userName :String,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        //
    }
    
    /** トピック作成 */
    func createTopic(topicName :String,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        
    }
    
    /** トピック編集 */
    func updateTopic(topicName :String,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        
    }
    
    /** トピック一覧取得 */
    func getTopics(groupId :Int,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        var json :Array<[String : AnyObject]> = [
            [
                "id" : 1,
                "name" : "トーク内容"
            ],
            [
                "id" : 2,
                "name" : "呼びたいゲスト"
            ],
            [
                "id" : 3,
                "name" : "食べ歩きもやりたいYo!"
            ]
        ]
        return block(result: json, error: nil)
    }
    
    /** ネタ作成 */
    func createIdea(content :String, anonymity :Bool,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        
    }
    
    /** ネタ削除 */
    func deleteIdea(ideaId :Int,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        
    }
    
    /** ネタ一覧取得 */
    func getIdeas(topidId :Int, block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        var json :Array<[String : AnyObject]> = [
            [
                "id" : 1,
                "content" : "タコベル食レポ",
                "like_count" : 1,
                "created_at" : "2015-05-02 10:01:33"
            ],
            [
                "id" : 2,
                "content" : "須川さんに聞く、今年は何人の男と付き合うのか",
                "like_count" : 13,
                "created_at" : "2015-05-01 10:01:33"
            ],
            [
                "id" : 3,
                "content" : "夏休みの児童向け　俺が考えた怖い話スペシャルーーー　脱稲川淳二 いけいけGOGO7188 メリーゴーランド",
                "like_count" : 3,
                "created_at" : "2015-04-14 10:01:33"
            ]
        ]
        return block(result: json, error: nil)
    }
    /** イイね */
    func createLike(ideaId :Int,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        
    }
    
    /** イイね一覧 */
    func getLikes(ideaId :Int,
        block :(result :Array<[String : AnyObject]>?, error :NSError?) -> Void) {
        //
    }
    
    /** 一休さんに訊こう */
    func getIdeaFromIkyusan() {
        
    }
    
    /** プロフィール編集 */
    func updateAccount() {
        
    }
}
