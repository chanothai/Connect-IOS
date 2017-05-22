//
//  ModelCart.swift
//  Connect4.0
//
//  Created by Pakgon on 5/22/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class ModelCart {
    private static var me:ModelCart?
    private var logingResult:LoginResult?
    
    init() {
        logingResult = LoginResult()
    }
    
    public static func getInstance() -> ModelCart {
        if me == nil {
            me = ModelCart()
        }
        return me!
    }
    
    public func getLoginResult() -> LoginResult {
        return logingResult!
    }
}
