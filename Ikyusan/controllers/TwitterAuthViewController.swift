//
//  TwitterAuthViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/06/13.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import WebKit
import SloppySwiper
import ObjectMapper
import SnapKit
import SloppySwiper

class TwitterAuthViewController: UIViewController,
    WKNavigationDelegate, WKUIDelegate {

    var webView = WKWebView()

    var flag = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self
        self.webView.UIDelegate = self

        //temp
        self.webView.frame = CGRectMake(0, 0, 320, 480)
        self.view.addSubview(self.webView)
        self.webView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }

        NSURLCache.sharedURLCache().diskCapacity = 0 // not to cache

        var cacheDir = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory,
            inDomain: NSSearchPathDomainMask.UserDomainMask,
            appropriateForURL: nil, create: false, error: nil)
        if let dir = cacheDir {
            dir.removeAllCachedResourceValues()
        }

        var libPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory,
            NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var cookiePath = libPath + "/Cookies"
        print(cookiePath)
        NSFileManager.defaultManager().removeItemAtPath(cookiePath, error: nil)

        /*
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
*/

        var cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for c in cookieStorage.cookies! {
            var cc = c as! NSHTTPCookie
            print(cc.domain)
            cookieStorage.deleteCookie(c as! NSHTTPCookie)
        }
//        var cookies = cookieStorage.cookiesForURL(NSURL(string: "http://ikyusan.sekahama.club")!)
//        for c in cookies! {
//            cookieStorage.deleteCookie(c as! NSHTTPCookie)
//        }

        var request = NSURLRequest(URL: NSURL(string: "http://ikyusan.sekahama.club/auth/twitter")!)
        self.webView.loadRequest(request)
    }

    override func viewDidLayoutSubviews() {
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        var requestString = navigationAction.request.URL!.absoluteString!

        if requestString.hasPrefix(ApiHelper.sharedInstance.kBaseUrl + "/auth/twitter") {

            self.webView.hidden = true
            showLoading()
            flag = true
        }

        decisionHandler(WKNavigationActionPolicy.Allow)
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if !flag {
            return
        }

        webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (var html, error) -> Void in
            print(html)

            // ここからworkaround、ちょっと危険かもしれない・・・

            html = html.stringByReplacingOccurrencesOfString("<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">",
                withString: "", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, html.length))
            html = html.stringByReplacingOccurrencesOfString("</pre>",
                withString: "", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, html.length))

            print(html)

            var jsonData = NSData(data: html.dataUsingEncoding(NSUTF8StringEncoding)!)

            var dic: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: nil)

            if dic == nil {
                print("error!!")
                return
            }

            var data = Mapper<Signup>().map(dic)

            if let d = data {
                AccountHelper.sharedInstance.setSingUp(d)

                //temp
                var vc = GroupListViewController(nibName: "GroupListViewController", bundle: nil)
                var nav = UINavigationController(rootViewController: vc)
                var swiper = SloppySwiper(navigationController: nav)
                nav.delegate = swiper
                self.navigationController?.presentViewController(nav, animated: true, completion: nil)
            }
        })
    }

    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
       //
    }


}
