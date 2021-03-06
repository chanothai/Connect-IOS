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

    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    var nearbyPermission: GNSPermission?
    var blocViewController: BlocViewController?
    
    var listBeacon:[BeaconModel]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        checkLogin()
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().barTintColor = UIColor.white

        /*
        nearbyPermission = GNSPermission(changedHandler: { (granted: Bool) in
            //Update the UI here
            if granted {
                print("Deny")
                GNSPermission.setGranted(false)
            }else{
                print("Allow")
                GNSPermission.setGranted(true)
            }
        })
         */
        
        GNSPermission.setGranted(true)
 
        // Enable debug logging to help track down problems.
        //GNSMessageManager.setDebugLoggingEnabled(true)
        
        // Create the message manager, which lets you publish messages and subscribe to messages
        // published by nearby devices.
        createMessageManager()
        setupStartStop()
        
        //Firebase
        FirebaseApp.configure()
        
        //Start register for remote
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in})
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func applicationStateString() -> String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        } else {
            return "inactive"
        }
    }
    
    func setupStartStop() {
        let isSharing = (publication != nil)
        if isSharing {
            print("Stop")
            stopSharing()
        }else{
            print("Start")
            startSharingWithRandomName()
        }
    }
    
    func createMessageManager(){
        messageMgr = GNSMessageManager(apiKey: "AIzaSyAXEoq9fS9iT3ShvcMD_DiJOZdbOZ-SEbs", paramsBlock: { (params: GNSMessageManagerParams?) -> Void in
            guard let params = params else { return }
            // This is called when microphone permission is enabled or disabled by the user.
            params.microphonePermissionErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if microphone use is allowed")
                }
            }
            
            // This is called when Bluetooth permission is enabled or disabled by the user.
            params.bluetoothPermissionErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if Bluetooth use is allowed")
                }
            }
            
            // This is called when Bluetooth is powered on or off by the user.
            params.bluetoothPowerErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if Bluetooth is turned on")
                }
            }
        })
    }
    
    
    /// Starts sharing with a randomized name.
    func startSharingWithRandomName() {
        hasDeviceKey(uuid: String(format:"Anonymous %d", arc4random() % 100))
    }
    
    /// Stops publishing/subscribing.
    func stopSharing() {
        publication = nil
        subscription = nil
        setupStartStop()
    }
    
    func hasDeviceKey(uuid: String) {
        let preference = UserDefaults.standard
        if let key = preference.string(forKey: "UUID_KEY"){
            startSharing(withName: key)
        }else{
            preference.set(uuid, forKey: "UUID_KEY")
            startSharing(withName: uuid)
        }
    }
    
    /// Starts publishing the specified name and scanning for nearby devices that are publishing
    /// their names.
    func startSharing(withName name: String) {
        if let messageMgr = self.messageMgr {
            // Show the name in the message view title and set up the Stop button.
            print("Name: \(name)")
            
            // Publish the name to nearby devices.
            /*
            let pubMessage: GNSMessage = GNSMessage(content: name.data(using: .utf8, allowLossyConversion: true))
            publication = messageMgr.publication(with: pubMessage)
 */
            
            // Subscribe to messages from nearby devices and display them in the message view.
            subscription = messageMgr.subscription(messageFoundHandler: {(message: GNSMessage?) -> Void in
                guard let message = message else { return }
                
                // Add device to stack for send data to webview
                let device = String(data: message.content, encoding:.utf8)
                
                var parameter = [String: String]()
                parameter["device"] = device
                
                NearbyManager.getInstance().setlistBeacon(model: parameter)
            
                print("MessageEDDHandlerFoundDevice: \(device ?? "Null"))")
                print("MessageEDDHandlerFound: \(NearbyManager.getInstance().getListBeacon())")
                print("MessageSpace: \(message.description)")
                
            },messageLostHandler: {(message: GNSMessage?) -> Void in
                guard let message = message else { return }
                
                let device = String(data: message.content, encoding:.utf8)
                let listBeacon = NearbyManager.getInstance().getListBeacon()
                
                for i in 0 ..< listBeacon.count {
                    if device == listBeacon[i]["device"] {
                        var listBeacon = NearbyManager.getInstance().getListBeacon()
                        listBeacon.remove(at: i)
                        NearbyManager.getInstance().updateListBeacon(arrBeacon: listBeacon)
                        print("MessageEDDHandlerLost: \(NearbyManager.getInstance().getListBeacon())")
                    }
                }
            },paramsBlock: { (params: GNSSubscriptionParams!) in
                params.deviceTypesToDiscover = .bleBeacon
                params.beaconStrategy = GNSBeaconStrategy(paramsBlock: { (params: GNSBeaconStrategyParams!) in
                    params.includeIBeacons = false
                    params.lowPowerPreferred = false
                })
                params.permissionRequestHandler = { (permissionHandler: GNSPermissionHandler!) in
                    // Show your custom dialog here, and don't forget to call permissionHandler after it is dismissed
                    print("Dialog dismissed")
                }
            })
        }
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
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print("Message Id: \((userInfo["gcm.message_id"])!)")
        print("UserInfo2: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Let FCM know about message for anlytice etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        //Print message id
        print("Message ID: \((userInfo["gcm.message_id"])!)")
        
        //Print full message
        print("UserInfo title : \(userInfo["title"] ?? "")")
        print("UserInfo body : \(userInfo["body"] ?? "")")
        print("UserInfo badge : \(userInfo["badge"] ?? "")")
        
        guard let title = userInfo["title"], let body = userInfo["body"], let badge = userInfo["badge"] else {
            return
        }
        
        if #available(iOS 10.0, *) {
            let notify = UNMutableNotificationContent()
            notify.title = title as! String
            notify.body = body as! String
            notify.badge = badge as? NSNumber
            
            UIApplication.shared.applicationIconBadgeNumber = Int(badge as! String)!
            
            let request = UNNotificationRequest(identifier: "notify_content", content: notify, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                print(error as Any)
            })
            
        } else {
            // Fallback on earlier versions
        }
        
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
        print("AppState : EnterBackground")
    }
    
    //End disconnect from fcm

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("AppState : EnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("AppState : WillTerminate")
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound, .badge, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
