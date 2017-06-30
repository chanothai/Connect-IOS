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
    public func showMessageRegister(title: String, message: String, isAction:Bool, username: String) {
        self.username = username
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isAction {
            alertController.addTextField { (textField: UITextField) in
                let height = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
                
                textField.addConstraint(height)
                textField.keyboardType = .numberPad
                textField.placeholder = "PIN CODE"
                textField.textColor = UIColor.darkGray
                textField.font = UIFont(name: "supermarket", size: 28)
                textField.addTarget(self, action: #selector(self.textFieldChange), for: UIControlEvents.editingChanged)
            }
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: actionPIN))
        }else{
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        self.mySelf?.show(alertController, sender: nil)
    }
    
    @objc func textFieldChange(textField: UITextField) {
        resultPin = textField.text
    }
    
    func actionPIN(action: UIAlertAction) {
        var parameters = [String: String]()
        parameters[UserVerify.username] = username
        parameters[UserVerify.pinCode] = resultPin
        
        SwiftEventBus.post("RegisterSuccess", sender: parameters)
    }
}
