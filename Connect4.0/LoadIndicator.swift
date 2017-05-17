//
//  LoadIndicator.swift
//  Connect4.0
//
//  Created by Pakgon on 5/17/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class LoadIndicator {
    private var mySelf:UIViewController?
    
    init(_ mySelf:UIViewController) {
        self.mySelf = mySelf
    }
    
    func showLoadingDialog() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        mySelf?.present(alert, animated: true, completion: nil)
    }
    
    func dissmissLoadingDialog() {
        mySelf?.dismiss(animated: false, completion: nil)
    }
}
