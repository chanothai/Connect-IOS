//
//  AppDelegate.swift
//  Connect4.0
//
//  Created by Pakgon on 5/5/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SWRevealViewController
import SwiftEventBus
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //UIApplication.shared.applicationIconBadgeNumber = 0
        
        checkLogin()
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().barTintColor = UIColor.white
        
        Messaging.messaging().delegate = self
        //Firebase
        FirebaseApp.configure()
        
        //Start register for remote
        if #available(iOS 10.0, *) {
            //For ios10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in})
        }else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }

    func checkLogin() {
        let restore = AuthenLogin().restoreLogin()
        if restore.count > 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let revealController = storyBoard.instantiateViewController(withIdentifier: "RevealController") as! SWRevealViewController
            self.window?.rootViewController = revealController
            self.window?.makeKeyAndVisible()
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
            self.window?.rootViewController = loginController
            self.window?.makeKeyAndVisible()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Send APNs token from Apple to FCM Server.
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        
    }
    
    // Start Receive Message
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Message Id: \((userInfo["gcm.message_id"])!)")
        print("UserInfo: \(userInfo)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Let FCM know about message for anlytice etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        //Print message id
        print("Message ID: \((userInfo["gcm.message_id"])!)")
        
        //Print full message
        print("UserInfo : \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // End Receive Message
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    // Start disconnect from fcm
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if Messaging.messaging().shouldEstablishDirectChannel {
            print("Disconnect from FCM.1")
        }else{
            print("Disconnect from FCM.2")
        }
    }
    //End disconnect from fcm

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate: MessagingDelegate {
    // Start refresh Token
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase register token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // End RefreshToken
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
        
    }
    // [END ios_10_data_message]
}

