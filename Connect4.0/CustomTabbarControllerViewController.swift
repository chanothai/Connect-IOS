//
//  CustomTabbarControllerViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 11/15/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import UserNotifications
import Localize_Swift

class CustomTabbarControllerViewController: UITabBarController {
    
    public static var beginLanguage:String?
    
    var conHome: BlocViewController?
    var conNotic: TabNoticViewController?
    var conListName: TabListNameController?
    var conProfile: TabProfileController?
    
    var urlBloc: String?
    var webView: UIWebView?
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            
        }
        
        self.delegate = self
        // Do any additional setup after loading the view.
        conHome = storyBoard.instantiateViewController(withIdentifier: "BlocController") as? BlocViewController
        if let beginLanguage = CustomTabbarControllerViewController.beginLanguage {
            conHome?.beginLanguage = beginLanguage
        }
        
        conHome?.tabBarItem.title = "Home".localized()
        conHome?.tabBarItem.tag = 1
        conHome?.tabBarItem.image = UIImage(named: "tabbar_home")
        let navHome = UINavigationController(rootViewController: conHome!)
        
        conNotic = storyBoard.instantiateViewController(withIdentifier: "TabNoticController") as? TabNoticViewController
    
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            conNotic?.tabBarItem.badgeValue = ""
        }else{
            conNotic?.tabBarItem.badgeValue = .none
        }
        
        conNotic?.tabBarItem.title = "Alert".localized()
        conNotic?.tabBarItem.tag = 2
        if #available(iOS 10.0, *) {
            conNotic?.tabBarItem.badgeColor = UIColor.red
        } else {
            // Fallback on earlier versions
        }
        
        conNotic?.tabBarItem.image = UIImage(named: "tabbar_notic")
        let navNotic = UINavigationController(rootViewController: conNotic!)
        
        let conScanQR = storyBoard.instantiateViewController(withIdentifier: "TabScanQRController") as! TabScanQRController
        conScanQR.tabBarItem.tag = 3
        conScanQR.tabBarItem.image = UIImage(named: "")
        
        conListName = storyBoard.instantiateViewController(withIdentifier: "TabListNameController") as? TabListNameController
        conListName?.tabBarItem.title = "Contact".localized()
        conListName?.tabBarItem.tag = 4
        conListName?.tabBarItem.image = UIImage(named: "tabbar_contact")
        let navListName = UINavigationController(rootViewController: conListName!)
        
        conProfile = storyBoard.instantiateViewController(withIdentifier: "TabProfileController") as? TabProfileController
        conProfile?.tabBarItem.title = "Profile".localized()
        conProfile?.tabBarItem.tag = 5
        conProfile?.tabBarItem.image = UIImage(named: "tabbar_profile")
        let navListProfile = UINavigationController(rootViewController: conProfile!)
        
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

@available(iOS 10.0, *)
extension CustomTabbarControllerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        let userInfo = notification.request.content.userInfo
        print("Notify : \(userInfo)")
        
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            conNotic?.tabBarItem.badgeValue = ""
        }else{
            conNotic?.tabBarItem.badgeValue = .none
        }
        
        completionHandler([.alert, .badge,.sound])
        
        guard let aps = userInfo["aps"] as? NSDictionary, let alert = aps["alert"] as? NSDictionary, let body = alert["body"] as? String, let title = alert["title"] as? String, let badge = aps["badge"] as? Int else {
        
            return
        }
        
        print("Message ID: \(userInfo["gcm.message_id"] ?? "")")
        print("UserInfo: \(userInfo)")
        print("Body : \(body)")
        print("Title : \(title)")
        print("Badge : \(badge)")
        
        if !title.isEmpty {
            // Change this to your preferred presentation option
            completionHandler([.alert, .badge,.sound])
        }
        
        UIApplication.shared.applicationIconBadgeNumber = badge
        print("Badge count: \(UIApplication.shared.applicationIconBadgeNumber)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notify : \(userInfo)")
        print("Message ID: \(userInfo["gcm.message_id"] ?? "")")
        print("UserInfo: \(userInfo)")
        
        // Change this to your preferred presentation option
        completionHandler()
    }
}

extension CustomTabbarControllerViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        switch tabBarController.selectedIndex {
        case 0:
            if let beginLanguage = CustomTabbarControllerViewController.beginLanguage {
                conHome?.beginLanguage = beginLanguage
            }
            
            conHome?.initWebView((conHome?.getUrl())!, webview: (conHome?.getWebview())!)
            self.selectedIndex = 0
            
            break
        case 1:
            if let beginLanguage = CustomTabbarControllerViewController.beginLanguage {
                conNotic?.beginLanguage = beginLanguage
            }
            
            if (conNotic?.getLoadFirst())! {
                conNotic?.initWebView((conNotic?.getUrl())!, webview: (conNotic?.getWebview())!)
            }
            
            self.selectedIndex = 1
            if UIApplication.shared.applicationIconBadgeNumber > 0 {
                conNotic?.tabBarItem.badgeValue = ""
            }else{
                conNotic?.tabBarItem.badgeValue = .none
            }
            
            break
        case 3:
            if let beginLanguage = CustomTabbarControllerViewController.beginLanguage {
                conListName?.beginLanguage = beginLanguage
            }
            
            if (conListName?.getLoadFirst())! {
                conListName?.initWebView((conListName?.getUrl())!, webview: (conListName?.getWebview())!)
            }
            
            self.selectedIndex = 3
            break
        case 4:
            if let beginLanguage = CustomTabbarControllerViewController.beginLanguage {
                conProfile?.beginLanguage = beginLanguage
            }
            
            if(conProfile?.getLoadFirst())! {
                conProfile?.initWebView((conProfile?.getUrl())!, webview: (conProfile?.getWebview())!)
            }
            
            self.selectedIndex = 4
            break
        default:
            break
        }
    }
}
