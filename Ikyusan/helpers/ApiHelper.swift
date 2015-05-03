//
//  ApiHelper.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Alamofire

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
    func createGroup() {
        
    }
    
    /** グループ編集 */
    func updateGroup() {
        
    }
    
    /** グループ一覧取得 */
    func getGroups() {
        
    }
    
    /** グループへの招待 */
    func createInviteGroup() {
        
    }
    
    /** トピック作成 */
    func createTopic() {
        
    }
    
    /** トピック編集 */
    func updateTopic() {
        
    }
    
    /** トピック一覧取得 */
    func getTopics() {
        
    }
    
    /** ネタ作成 */
    func createIdea() {
        
    }
    
    /** ネタ削除 */
    func deleteIdea() {
        
    }
    
    /** ネタ一覧取得 */
    func getIdeas() {
        
    }
    
    /** イイね */
    func createLike() {
        
    }
    
    /** イイね一覧 */
    func getLikes() {
        
    }
    
    /** 一休さんに訊こう */
    func getIdeaFromIkyusan() {
        
    }
    
    /** プロフィール編集 */
    func updateAccount() {
        
    }
}
