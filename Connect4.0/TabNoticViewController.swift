//
//  TabNoticViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 11/15/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class TabNoticViewController: BaseViewController {

    // Make: outlet
    @IBOutlet var webView: UIWebView!
    
    // Make: properties
    var titleBarItem: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBarItem = "การแจ้งเตือน"
        self.navigationItem.titleView = self.customTitle(titleBarItem!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.initWebView("http://connect06.pakgon.com/core/Homes/alert")
        
        self.tabBarItem.badgeValue = .none
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
