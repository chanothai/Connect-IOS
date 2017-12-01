//
//  TabListNameController.swift
//  Connect4.0
//
//  Created by Pakgon on 11/15/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class TabListNameController: BaseViewController {

    //Make : outlet
    @IBOutlet var webView: UIWebView!
    
    //Make: properties
    var url = "http://connect06.pakgon.com/core/Homes/contact"
    var beginLanguage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let titleBarItem = "รายชื่อติดต่อ"
        self.navigationItem.titleView = self.customTitle(titleBarItem)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initWebView(url)
    }
    
    func initWebView(_ url: String){
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        
        if let beginLanguage = beginLanguage {
            self.webView.loadRequest(WebAppRequest(url: url).getUrlRequest(language: beginLanguage))
            
        }else{
            let langStr = Locale.current.languageCode
            let regionCode = Locale.current.regionCode
            print("Language-Code : \(langStr!)")
            print("Region-Code : \(regionCode!)")
            self.webView.loadRequest(WebAppRequest(url: url).getUrlRequest(language: langStr!))
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
            self.dismiss(animated: true, completion: nil)
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
