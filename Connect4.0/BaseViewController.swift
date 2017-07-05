//
//  BaseViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import MBProgressHUD
import SWRevealViewController

class BaseViewController: UIViewController {

    let screenSize:Int = Int(UIScreen.main.bounds.width)
    let baseScreen:Int = 350
    let baseFont = "supermarket"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BaseViewController {
    public func createBarButtonItemBase() -> UIBarButtonItem{
        let toggle = UIBarButtonItem(image: UIImage(named: "menu_toggle"), style: .plain, target: self, action: nil)
        return toggle
    }
    
    public func createItemRightBase(_ point: Int) -> UIBarButtonItem {
        let widthToolbar = (navigationController?.view.frame.width)! / 3
        
        let layout = UIStackView(frame: CGRect(x: 0, y: 0, width: widthToolbar, height: (navigationController?.view.frame.height)!))
        layout.spacing = 4
        layout.alignment = .fill
        
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30 , height: 30))
        icon.image = UIImage(named: "point")
        icon.contentMode = .scaleAspectFit
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: Int(icon.frame.width), height: Int(icon.frame.height)))
        label.textAlignment = .right
        label.text = String(point)
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.clear
        
        layout.addArrangedSubview(label)
        layout.addArrangedSubview(icon)
        
        let barButton = UIBarButtonItem(customView: layout)
        return barButton
    }
    
    public func createTitleBarImage() -> UIImageView {
        let logo = UIImage(named: "logo-titlebar")
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imgView.image = logo
        
        return imgView
    }
    
    public func customTitle(_ title: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2 , height: (navigationController?.view.frame.height)!))
        label.font = UIFont(name: "supermarket", size: 20)
        label.textColor = UIColor.darkGray
        label.text = title
        label.textAlignment = .center
        
        return label
    }
}

extension BaseViewController: BaseViewModelDelegate {
    public func showLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading..."
        loadingNotification.mode = .indeterminate
    }
    
    public func hideLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    public func onDataDidLoad() {
        
    }
    
    public func onDataDidLoadErrorWithMessage(errorMessage: String) {
        
    }
    
    func setSideBar() {
        if (self.revealViewController() != nil) {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.leftBarButtonItem?.target = revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
}

extension UITableView {
    public func setBaseTableStyle(){
        self.backgroundColor = UIColor.clear
        self.tableFooterView = UIView(frame: CGRect.zero) //remove empty rows of table
        self.separatorColor = UIColor.clear
    }
}

