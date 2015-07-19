//
//  LikeHelper.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/04.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import pop

class LikeHelper: NSObject {
    
    private var timer :NSTimer?
    
    private var poolCount = 0
    
    private var groupId = 0
    private var topicId = 0
    private var currentTargetIdeaId = 0
   
    //singleton
    class var sharedInstance : LikeHelper {
        struct Static {
            static let instance : LikeHelper = LikeHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // memo :APIの仕様上設ける
    func setBaseInfo(groupId :Int, topicId :Int) {
        self.groupId = groupId
        self.topicId = topicId
    }
    
    func doLike(ideaId :Int) {
        if let t = timer {
            if ideaId != currentTargetIdeaId {
                requestLike(currentTargetIdeaId, count: self.poolCount)
                currentTargetIdeaId = ideaId
                poolCount = 0
            }
            poolCount++
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                target: self,
                selector: "timerEnded",
                userInfo: nil,
                repeats: false)
        } else {
            poolCount = 1
            currentTargetIdeaId = ideaId
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                target: self,
                selector: "timerEnded",
                userInfo: nil,
                repeats: false)
        }
    }
    
    func timerEnded() {
        //API
        requestLike(currentTargetIdeaId, count: self.poolCount)
        
        self.reset()
    }
    
    func requestLike(ideaId :Int, count :Int) {
        
        if self.groupId == 0 || self.topicId == 0 {
            return
        }
        
        ApiHelper.sharedInstance.call(ApiHelper.CreateLike(groupId: self.groupId, topicId: self.topicId,
            ideaId: ideaId, num: count)) { response in
            switch response {
            case .Success(let box):
                println(box.value) // Message
                
            case .Failure(let box):
                println(box.value) // NSError
            }
        }
        
        
        NSLog("ideaId:%d, count:%d", ideaId, count)
    }
    
    private func reset() {
        timer?.invalidate()
        timer = nil
        poolCount = 0
    }

    // MARK: - animation

    class func animationStart(targetView :UIView) {
        var animation = POPSpringAnimation()

        animation.property = POPAnimatableProperty.propertyWithName(kPOPLayerPositionY) as! POPAnimatableProperty
        animation.fromValue = NSValue(CGPoint: CGPointMake(0.0, 0.0))
        animation.toValue = NSValue(CGPoint: CGPointMake(1, 1))

        animation.springBounciness = 12.0
        animation.springSpeed = 20.0

        targetView.layer.pop_addAnimation(animation, forKey: "AnimationScale")
    }
}
