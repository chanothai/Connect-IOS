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
    // Make : properties
    let screenWidth:Int = Int(UIScreen.main.bounds.width)
    let screenHeight:Int = 350
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

extension UILabel {
    func resizeFont(){
        let currentFontName = self.font.fontName
        let fontSize = self.font.pointSize
        var calculatedFont: UIFont?
        let height = UIScreen.main.bounds.size.height
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        case 568.0: //iphone 5, 5s => 4 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        case 667.0: //iphone 6, 6s => 4.7 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        default:
            print("not an iPhone")
            break
        }
    }
}

extension UIImageView {
    func multiSizeImage(layout: UIStackView){
        let screen = UIScreen.main.bounds.size.height
        switch screen {
        case 568.0 :
            let size: Int = 100
            let heightImg = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(size))
            
            let widthImg = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(size))
            
            self.layer.cornerRadius = CGFloat(size / 2)
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 1
            
            layout.addConstraints([widthImg,heightImg])
            break
        case 667.0:
            break
        default:
            break
        }
    }
}

extension UIWebView {
    func initWebView(_ url: String){
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        let langStr = Locale.current.languageCode
        self.loadRequest(WebAppRequest(url: url).getUrlRequest(language: langStr!, token: ""))
    }
    
    func callJSMethod(name: String, agruments: String...) -> String?{
        var agrumentString = ""
        for agrument in agruments {
            if agrumentString.characters.count > 0 {
                agrumentString = "\(agrumentString),"
            }
            agrumentString = "\(agrumentString)'\(agrument)'"
        }
        
        print("Script: \(agrumentString)")
        return self.stringByEvaluatingJavaScript(from: "\(name)(\(agrumentString))")
    }
    
    func callUpdateBeacon(name: String, listBeacon: [String], token: String) {
        print("Stript: \(name)('\(listBeacon)','\(token)')")

        self.stringByEvaluatingJavaScript(from: "\(name)('\(listBeacon)','\(token)')")
    }
}

