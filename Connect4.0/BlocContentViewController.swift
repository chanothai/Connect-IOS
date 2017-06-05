//
//  BlocContentViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/1/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import WebKit

class BlocContentViewController: UIViewController {

    //MAKE: outlet
    var webView = WKWebView()
    var progBar = UIProgressView()
    
    //MAKE: properties
    var pathURL:String?
    var blocInformation:Bloc?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        progBar = UIProgressView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 50))
        progBar.progress = 0.0
        progBar.tintColor = UIColor.cyan
        webView.addSubview(progBar)

        
        if let url = URL(string: (blocInformation?.bloc_url)!) {
            let request = URLRequest(url: url)
            webView.load(request)
            webView.navigationDelegate = self
        }
        
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension BlocContentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let restore = AuthenLogin().restoreLogin()
        print(restore[1])
        let injectToken:String = "javascript:(function() {var inputs = document.getElementById('UserToken');inputs.value='"+restore[1]+"';document.forms[0].submit();})();"
        print(injectToken)
        webView.evaluateJavaScript(injectToken, completionHandler: nil)
    }
}
