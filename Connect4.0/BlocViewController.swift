//
//  BlocViewController.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SWRevealViewController
import SwiftEventBus
import CoreLocation
import UserNotifications
import Firebase


class BlocViewController: BaseViewController {
    //MAKE : outlet
    @IBOutlet var webView: UIWebView!

    //MAKE : Properties
    public var token: String?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var locationManager:CLLocationManager?
    var region:[CLBeaconRegion]?
    var count:Int = 0
    var urlBloc: String?
    var beginLanguage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        self.navigationItem.titleView = self.createTitleBarImage()
        self.setSideBar()
        
        setEventBus()
        initBlocMain()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        locationManager?.stopUpdatingLocation()
        ModelCart.getInstance().getStoreUrl().url = ""
        SwiftEventBus.unregister(self)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension BlocViewController {
    func initLocationManager() {
        locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    public func initBlocMain(){
        let restoreInformation:[String] = AuthenLogin().restoreLogin() //0 token, 1 web browser, subscribe for topic firebase
        token = restoreInformation[0]
        urlBloc = restoreInformation[1]
        let sub = restoreInformation[2]
        print(sub)
        
        //Subscribe to a topic after got a FCM Register token
        Messaging.messaging().subscribe(toTopic: "/topics/\(sub)")
        initWebView(urlBloc!, webview: webView)
        initLocationManager()
    }
    
    public func getWebview() -> UIWebView {
        return webView
    }
    
    public func getUrl() -> String {
        return urlBloc!
    }
    
    func initWebView(_ url: String, webview: UIWebView){
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.scrollView.bounces = false
        
        if let beginLanguage = beginLanguage {
            webview.loadRequest(WebAppRequest(url: url).getUrlRequest(language: beginLanguage))
            
            var parameter = [String: String]()
            parameter["language"] = beginLanguage
            
            SlideMenuRequest().request(parameter)
            
        }else{
            let langStr = Locale.current.languageCode
            let regionCode = Locale.current.regionCode
            print("Language-Code : \(langStr!)")
            print("Region-Code : \(regionCode!)")
            self.webView.loadRequest(WebAppRequest(url: url).getUrlRequest(language: langStr!))
            
            SlideMenuRequest().requestNonParameter()
        }
    }
    
    func pushToLogin() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
        self.navigationController?.pushViewController(loginController, animated: false)
    }
    
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "ResponseSlideMenu") { (result) in
            let response = result.object as! ResponseSlideMenu
            if response.status == "Success" {
                ModelCart.getInstance().getModelSlideMenu().result = response.result! // store data
            }
            
            print(response.status ?? "")
        }
    }
}

//Make: IBeacon
extension BlocViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            ModelCart.getInstance().getLocation().lat = "\(location.coordinate.latitude)"
            ModelCart.getInstance().getLocation().long = "\(location.coordinate.longitude)"
        }
    }
}
