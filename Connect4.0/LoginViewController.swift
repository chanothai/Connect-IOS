//
//  LoginViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/18/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SWRevealViewController
import WebKit

class LoginViewController: BaseViewController {

    // Make: View
    @IBOutlet var webView: UIWebView!
    
    var progBar = UIProgressView()
    
    // MAKE: properties
    var pathLogin: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JSInterface.delegate = self
        initWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView.removeJavascriptInterfaces()
    }
    
//    deinit {
//        self.webView.removeJavascriptInterfaces()
//    }
}

extension LoginViewController {
    func initWebView(){
        webView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.addJavascriptInterface(JSInterface(), forKey: "Login");
    
        loadWebView()
    }
    
    func loadWebView() {
        let langStr = Locale.current.languageCode
        self.webView.loadRequest(WebAppRequest(url: "http://connect06.pakgon.com/core").getUrlRequest(language: langStr!))
    }
    
    func intentToBloc() {
        performSegue(withIdentifier: "showMainController", sender: nil)
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let blocViewController = storyBoard.instantiateViewController(withIdentifier: "BlocController") as! BlocViewController
//        self.show(blocViewController, sender: nil)
        let result = webView.callJSMethod(name: "ShowAlert", agruments: "", "")
        print("CallJavascript: \(result!)")
    }
}

extension LoginViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
}

extension LoginViewController: OnLoginDelegate {
    func onLoginComplete(token: String, webURL: String, subscribe: String) {
        print(token)
        AuthenLogin().storeLogin(token, webURL, subscribe)
        intentToBloc()
    }
}

extension UIWebView {
    func callJSMethod(name: String, agruments: String...) -> String?{
        var agrumentString = ""
        for agrument in agruments {
            if agrumentString.characters.count > 0 {
                agrumentString = "\(agrumentString),"
            }
            agrumentString = "\(agrumentString)'\(agrument)'"
        }
        
        print(agrumentString)
        return self.stringByEvaluatingJavaScript(from: "\(name)(\(agrumentString))")
    }
}
