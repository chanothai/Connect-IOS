//
//  LoginJSInterface.swift
//  Connect4.0
//
//  Created by Pakgon on 11/7/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit

@objc protocol MyExport : JSExport
{
    func onLogin(_ arg1: String, _ arg2: String, _ arg3: String)
}

protocol OnLoginDelegate {
    func onLoginComplete(token :String, webURL :String, subscribe: String)
}

class JSInterface : NSObject, MyExport
{
    public static var delegate: OnLoginDelegate?
    func onLogin(_ arg1: String, _ arg2: String, _ arg3: String) {
        print("\(arg1), \(arg2)")
        if (!arg1.isEmpty && !arg2.isEmpty) {
            JSInterface.delegate?.onLoginComplete(token: arg1, webURL: arg2, subscribe: arg3)
        }
    }
}

