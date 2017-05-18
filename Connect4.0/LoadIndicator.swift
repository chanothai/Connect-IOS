//
//  LoadIndicator.swift
//  Connect4.0
//
//  Created by Pakgon on 5/17/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import MBProgressHUD
import UIKit

class LoadIndicator {
    private static var me:LoadIndicator?
    private var mySelf:UIViewController?
    private var overlay:UIView!
    
    init(_ mySelf:UIViewController) {
        self.mySelf = mySelf
        overlay = UIView(frame: (mySelf.view.frame))
    }
    
    static func getInstance(_ mySelf: UIViewController) -> LoadIndicator {
        if me == nil {
            me = LoadIndicator(mySelf)
        }
        return me!
    }
    
    func showLoadingDialog() {
        overlay?.backgroundColor = UIColor.black
        overlay?.alpha = 0.3
        
        mySelf?.view.addSubview(overlay!)
        
        let hud = MBProgressHUD.showAdded(to: (mySelf?.view)!, animated: true)
        hud.label.text = "Loading..."
    }
    
    func dissmissLoadingDialog() {
        overlay?.removeFromSuperview()
        MBProgressHUD.hide(for: (mySelf?.view)!, animated: true)
    }
}
