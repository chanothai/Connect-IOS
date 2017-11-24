//
//  CustomTabbarControllerViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 11/15/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class CustomTabbarControllerViewController: UITabBarController {

    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let conHome = storyBoard.instantiateViewController(withIdentifier: "BlocController") as! BlocViewController
        conHome.tabBarItem.title = "หน้าหลัก"
        conHome.tabBarItem.tag = 1
        conHome.tabBarItem.image = UIImage(named: "tabbar_home")
        let navHome = UINavigationController(rootViewController: conHome)
        
        let conNotic = storyBoard.instantiateViewController(withIdentifier: "TabNoticController") as! TabNoticViewController
        conNotic.tabBarItem.title = "การแจ้งเตือน"
        conNotic.tabBarItem.tag = 2
        if #available(iOS 10.0, *) {
            conNotic.tabBarItem.badgeColor = UIColor.red
        } else {
            // Fallback on earlier versions
        }
        conNotic.tabBarItem.image = UIImage(named: "tabbar_notic")
        let navNotic = UINavigationController(rootViewController: conNotic)
        
        let conScanQR = storyBoard.instantiateViewController(withIdentifier: "TabScanQRController") as! TabScanQRController
        conScanQR.tabBarItem.title = ""
        conScanQR.tabBarItem.tag = 3
        conScanQR.tabBarItem.image = UIImage(named: "")
        
        let conListName = storyBoard.instantiateViewController(withIdentifier: "TabListNameController") as! TabListNameController
        conListName.tabBarItem.title = "รายชื่อ"
        conListName.tabBarItem.tag = 4
        conListName.tabBarItem.image = UIImage(named: "tabbar_contact")
        let navListName = UINavigationController(rootViewController: conListName)
        
        let conProfile = storyBoard.instantiateViewController(withIdentifier: "TabProfileController") as! TabProfileController
        conProfile.tabBarItem.title = "โปรไฟล์"
        conProfile.tabBarItem.tag = 4
        conProfile.tabBarItem.image = UIImage(named: "tabbar_profile")
        let navListProfile = UINavigationController(rootViewController: conProfile)
        
        viewControllers = [navHome, navNotic, conScanQR, navListName ,navListProfile]
        
        setupMiddleTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMiddleTab(){
        let tabScan = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        tabScan.frame.origin.y = view.bounds.height - (tabScan.frame.height)
        tabScan.frame.origin.x = (view.bounds.width / 2) - (tabScan.frame.size.width / 2)
        
        tabScan.backgroundColor = UIColor.clear
        tabScan.setBackgroundImage(UIImage(named: "tabbar_scanqr"), for: .normal)
        tabScan.layer.cornerRadius = tabScan.frame.height / 2
        
        view.addSubview(tabScan)

        tabScan.addTarget(self, action: #selector(selectTabScan(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc func selectTabScan(sender: AnyObject){
        self.selectedIndex = 2
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
