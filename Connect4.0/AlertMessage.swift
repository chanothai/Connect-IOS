//
//  AlertMessage.swift
//  Connect4.0
//
//  Created by Pakgon on 5/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController
import SwiftEventBus

class AlertMessage {
    private static var me: AlertMessage?
    private var mySelf:UIViewController?
    
    init(_ mySelf:UIViewController) {
        self.mySelf = mySelf
    }
    
    public static func getInstance(_ mySelf:UIViewController) -> AlertMessage {
        me = AlertMessage(mySelf)
        return me!
    }
    
    public func showMessageAuthen(title: String, message: String, isAction:Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isAction {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: setAction))
        }else{
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        mySelf?.present(alertController, animated: true, completion: nil)
    }
    
    private func setAction(action: UIAlertAction) {
        SwiftEventBus.post("LoginSuccess", sender: true)
    }
}
