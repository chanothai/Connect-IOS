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
    var webView: WKWebView!
    
    //MAKE: properties
    var pathURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "http://www.appcoda.com/contact") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
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
