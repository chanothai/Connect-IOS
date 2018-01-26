//
//  BlocContentViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/1/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import WebKit

class BlocContentViewController: BaseViewController {

    //MAKE: outlet
    var webView = WKWebView()
    var progBar = UIProgressView()
    
    //MAKE: properties
    var urlBloc:String?
    var titleName: String?  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.customTitle(titleName!)
        
        print(urlBloc!)
        initWebView()
        loadWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backWeb(_ sender: UIBarButtonItem) {
        if(webView.canGoBack) {
            webView.goBack()
        } else {
            //Pop view controller to preview view controller
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progBar.progress = Float(webView.estimatedProgress)
            
            if progBar.progress >= 1.0 {
                progBar.progress = 0.0
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}

extension BlocContentViewController {
    func initWebView(){
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        
        progBar = UIProgressView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 50))
        progBar.progress = 0.0
        progBar.tintColor = UIColor.cyan
        progBar.alpha = 1.0
        webView.addSubview(progBar)
    }
    
    func loadWebView() {
        let langStr = Locale.current.languageCode
        webView.load(WebAppRequest(url: urlBloc!).getUrlRequest(language: langStr!, token: ""))
        view.addSubview(webView)
    }
}

extension BlocContentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let restore = AuthenLogin().restoreLogin()
        let injectToken:String = "javascript:(window.object = function() {var inputs = document.getElementById('UserToken');inputs.value='"+restore[1]+"';document.forms[0].submit();})();"
        webView.evaluateJavaScript(injectToken, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == WKNavigationType.linkActivated) {
            //Detect click link from webview
            let url = navigationAction.request.url?.absoluteString
            print(url!)
            
            let checkFile = url?.components(separatedBy: ".")
            if (checkFile?.count)! > 3 {
                DownloadFile(self).pdf(url!)
            }
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
