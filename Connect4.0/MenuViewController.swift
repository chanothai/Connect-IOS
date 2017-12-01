//
//  MenuViewController.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SWRevealViewController
import AlamofireImage
import CoreLocation
import SwiftEventBus

class MenuViewController: BaseViewController {
    
    //Make: outlet
    @IBOutlet var sidebarMenuTableView: UITableView!
    @IBOutlet var profileIMG: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var layoutProfile: UIStackView!
    
    
    //Make: property
    var arrMenu:[String]!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var blurEffectView:UIVisualEffectView?
    var destinationController:UIViewController?
    var beginLanguage: String?
    
    fileprivate var viewModel: MenuSlideViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initAddress()
        initProfile()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension MenuViewController {
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "ResponseSlideMenu") { (result) in
            let response = result.object as? ResponseSlideMenu
            if response?.status == "Success" {
                ModelCart.getInstance().getModelSlideMenu().result = (response?.result)!
                
                self.initProfile()
                self.sidebarMenuTableView.reloadData()
                self.hideLoading()
                CustomTabbarControllerViewController.beginLanguage = self.beginLanguage
                let tabbar = self.storyBoard.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarControllerViewController
                self.revealViewController().pushFrontViewController(tabbar, animated: true)
            }
        }
    }
    
    func initTableView(){
        viewModel = MenuSlideViewModel()
        viewModel?.clickDelegate = self
        
        viewModel?.reloadSection = {[weak self] (section: Int) in
            self?.sidebarMenuTableView.beginUpdates()
            self?.sidebarMenuTableView.reloadSections([section], with: .fade)
            self?.sidebarMenuTableView.endUpdates()
        }
        
        sidebarMenuTableView.dataSource = viewModel
        sidebarMenuTableView.delegate = viewModel
        sidebarMenuTableView.setBaseTableStyle()
        
        sidebarMenuTableView.register(LanguageCell.nib, forCellReuseIdentifier: LanguageCell.identifier)
        sidebarMenuTableView.register(LogoutCell.nib, forCellReuseIdentifier: LogoutCell.identifier)
        sidebarMenuTableView.register(HeaderLanguageView.nib, forHeaderFooterViewReuseIdentifier: HeaderLanguageView.identifier)
    }
    
    func initProfile(){
        let name = "\((ModelCart.getInstance().getModelSlideMenu().result.data?.profiles?.firstName)!) \((ModelCart.getInstance().getModelSlideMenu().result.data?.profiles?.lastName)!)"
        
        nameLabel.resizeFont()
        nameLabel?.text = name
        
        profileIMG.multiSizeImage(layout: layoutProfile)
        profileIMG.layer.borderWidth = 1
        profileIMG.layer.borderColor = UIColor.darkGray.cgColor
        
        guard let url = URL(string: (ModelCart.getInstance().getModelSlideMenu().result.data?.profiles?.imgPath)!) else {
            print("IMAGE was null")
            profileIMG?.image = UIImage(named: "people")
            return
        }
        
        profileIMG?.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
    }
    
    func initAddress(){
        self.addressLabel.resizeFont()
        if let lat = ModelCart.getInstance().getLocation().lat, let lon = ModelCart.getInstance().getLocation().long {
            getAddressFromLatLon(latitude: lat, withLongitude: lon)
        }else{
            self.addressLabel.text = ""
        }
    }
    
    func getAddressFromLatLon(latitude: String, withLongitude longitude: String) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        let lon: Double = Double("\(longitude)")!
        let geo: CLGeocoder = CLGeocoder()
        
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        geo.reverseGeocodeLocation(loc) { (placeMaker, error) in
            let pm = placeMaker! as [CLPlacemark]
            if (pm.count > 0) {
                let pm = placeMaker![0]
                
                self.addressLabel.text = "\(pm.subLocality!), \(pm.thoroughfare!)"
            }
        }
    }
    
    public func actionSignOut(){
        let optionMenu = UIAlertController(title: nil, message: "if you sign out of your account, all your information will be removed from this app", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            self.intentToLogin()
        }
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default, handler: callActionHandler)
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(signOutAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func intentToLogin(){
        let loginController = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
        
        self.present(loginController, animated: true) {
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
        }
    }
    
    func setBackground() {
        let color1 = UIColor(colorLiteralRed: 57/255, green: 65/255, blue: 75/255, alpha: 1)
        let color2 = UIColor(colorLiteralRed: 114/255, green: 124/255, blue: 137/255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor , color2.cgColor]
        gradientLayer.frame = view.frame
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension MenuViewController: MenuSlideClickDelegat {
    func menuClicked(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sidebarMenuTableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 1 {
            actionSignOut()
        }else{
            var parameter = [String: String]()
            parameter["language"] = ModelCart.getInstance().getModelSlideMenu().result.data?.languages?.listLanguage?[indexPath.row].languageDesc
            beginLanguage = parameter["language"]
            
            showLoading()
            SlideMenuRequest().request(parameter)
        }
    }
}
