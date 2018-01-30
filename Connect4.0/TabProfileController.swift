//
//  TabProfileController.swift
//  Connect4.0
//
//  Created by Pakgon on 11/15/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class TabProfileController: BaseViewController {
    
    //Make: outlet
    @IBOutlet var webView: UIWebView!
    

    //Make: properies
    var url = "http://connect05.pakgon.com/core/Profiles"
    var beginLanguage: String?
    var loadFirst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let titleBarItem = "โปรไฟล์"
        self.navigationItem.titleView = self.customTitle(titleBarItem)
        
        loadFirst = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initWebView(url, webview: self.webView)
    }
    
    public func getLoadFirst() -> Bool {
        return self.loadFirst
    }
    
    public func getWebview() -> UIWebView {
        if let wv = webView {
            return wv
        }else{
            webView = UIWebView(frame: CGRect(x: 0, y: -16, width: 0, height: 0))
            return webView
        }
    }
    
    public func getUrl() -> String {
        return url
    }
    
    func initWebView(_ url: String, webview: UIWebView){
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        
        if let beginLanguage = beginLanguage {
            webView.loadRequest(WebAppRequest(url: url).getUrlRequest(language: beginLanguage, token: BlocViewController.token!))
            
        }else{
            let langStr = Locale.current.languageCode
            let regionCode = Locale.current.regionCode
            print("Language-Code : \(langStr!)")
            print("Region-Code : \(regionCode!)")
            webView.loadRequest(WebAppRequest(url: url).getUrlRequest(language: langStr!,token: BlocViewController.token!))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backScreen(_ sender: UIBarButtonItem) {
        if(webView.canGoBack) {
            webView.goBack()
        } else {
            //Pop view controller to preview view controller
            self.tabBarController?.selectedIndex = 0
        }
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
