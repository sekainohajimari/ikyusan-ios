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

            print(data)
        })
    }

    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
       //
    }


}
