//
//  AppDelegate.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SloppySwiper
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var swiper = SloppySwiper()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.setupAppearance()

//        Fabric.with([Crashlytics()])

//        AccountHelper.sharedInstance.delete(0)

        AccountHelper.sharedInstance.setTestId(25)
        print("testId = " + String(stringInterpolationSegment: AccountHelper.sharedInstance.getTestId()))

//        AccountHelper.sharedInstance.deleteAll()
        if AccountHelper.sharedInstance.getAccessToken() == nil {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            var vc = SignupViewController(nibName: "SignupViewController", bundle: nil)
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return true
        }

        //set first viewcontroller
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var vc = GroupListViewController(nibName: "GroupListViewController", bundle: nil)
        var nav = UINavigationController(rootViewController: vc)
        self.swiper = SloppySwiper(navigationController: nav)
        nav.delegate = self.swiper
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    private func setupAppearance() {
        //back button
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "button_back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "button_back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
}

