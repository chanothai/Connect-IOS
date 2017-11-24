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
    var beaconList:[(CLBeaconRegion, CLBeacon)]?
    var region:[CLBeaconRegion]?
    var count:Int = 0
    var urlBloc: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.createTitleBarImage()
        self.setSideBar()
        self.tabBarController?.delegate = self
        //Subscribe to a topic after got a FCM Register token
        Messaging.messaging().subscribe(toTopic: "/topics/coffee")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        initBlocMain()
        setEventBus()
        initBadge()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        locationManager?.stopUpdatingLocation()
        region?.forEach((locationManager?.stopRangingBeacons(in:))!)
        SwiftEventBus.unregister(self)
        ModelCart.getInstance().getStoreUrl().url = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension BlocViewController {
    func initBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 1) as! UITabBarItem
        tabItem.badgeValue = ""
    }
    
    func initLocationManager() {
        beaconList = [(CLBeaconRegion, CLBeacon)]()
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
        let restoreInformation:[String] = AuthenLogin().restoreLogin() //0 token, 1 web browser
        token = restoreInformation[0]
        urlBloc = restoreInformation[1]
        initWebView(urlBloc!)
        initLocationManager()
        
        showLoading()
        SlideMenuRequest().request()
    }
    
    func initWebView(_ url: String){
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        let langStr = Locale.current.languageCode
        webView.loadRequest(WebAppRequest(url: url).getUrlRequest(language: langStr!))
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
                self.hideLoading()
            }
            
            print(response.status ?? "")
        }
    }
}

//Make: IBeacon
extension BlocViewController : CLLocationManagerDelegate {
    func rangeBeacon() {
        region = [CLBeaconRegion]()
        region = [CLBeaconRegion(proximityUUID: UUID(uuidString: "7739BAE7-1027-4F48-8003-2C8140423002")! , identifier: "Beacon2"), CLBeaconRegion(proximityUUID: UUID(uuidString: "5152554E-F99B-4A3B-86D0-947070693A78")! , identifier: "Beacon1")]
        
        region?.forEach((locationManager?.startRangingBeacons(in:))!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            rangeBeacon()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoveredBeaconProximity = beacons.first?.proximity else {
            print("Cloudn't find the beacon")
            return
        }
        
        count += 1
        
        let seeUuid:String = (beacons.first?.proximityUUID.uuidString)!
        print("\(count) Beacon: " + seeUuid)
        
        let backgroundColor: UIColor = {
            switch discoveredBeaconProximity {
            case .unknown: return UIColor.black
            default : return UIColor.green
            }
        }()
        
        view.backgroundColor = backgroundColor
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            ModelCart.getInstance().getLocation().lat = "\(location.coordinate.latitude)"
            ModelCart.getInstance().getLocation().long = "\(location.coordinate.longitude)"
        }
    }
}

extension BlocViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        initWebView(urlBloc!)
    }
}

