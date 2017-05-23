//
//  LaunchScreenViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/23/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SwiftEventBus
import SWRevealViewController

class LaunchScreenViewController: BaseViewController {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClientHttp.getInstace().checkVersion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setEventBus(){
        SwiftEventBus.onMainThread(self, name: "CheckVersion") { (result) in
            let restore = AuthenLogin().restoreLogin()
            if restore.count > 0 {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let revealController = storyBoard.instantiateViewController(withIdentifier: "RevealController") as! SWRevealViewController
                self.window?.rootViewController = revealController
                self.window?.makeKeyAndVisible()
            }
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
