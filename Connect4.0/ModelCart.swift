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
    private var userInfo:UserInfoResponse?
    private var loginController:LoginViewController?
    
    init() {
        userInfo = UserInfoResponse()
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
    
    
    var getUserInfo:UserInfoResponse {
        get{
            return userInfo!
        }
        set{
            userInfo = newValue
        }
    }
}
