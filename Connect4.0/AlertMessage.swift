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
    var mySelf:UIViewController?
    var resultPin: String?
    var username: String?
    
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


extension AlertMessage {
    func showMessageForgotPassword(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        mySelf?.present(alertController, animated: true, completion: nil)
    }
}

extension UIAlertController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 4
    }
}
