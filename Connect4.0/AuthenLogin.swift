//
//  ValidateLogin.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

struct DefaultKey {
    static let usernameKey = "username_key"
    static let tokenKey = "token_key"
    static let dynamicKey = "dynamic_key"
    static let pinpasswordKey = "pinpassword_key"
}
class AuthenLogin {
    private var preference: UserDefaults?
    
    init() {
        preference = UserDefaults.standard
    }
    
    public func storePinPassword(_ pin: String) {
        preference?.set(pin, forKey: DefaultKey.pinpasswordKey)
        preference?.synchronize()
    }
    
    public func restorePinPassword() -> String {
        if let pinPassword = preference?.string(forKey: DefaultKey.pinpasswordKey){
            return pinPassword
        }
        
        return ""
    }
    
    public func storeLogin(_ username:String, _ token:String, _ key:String) {
        preference?.set(username, forKey: DefaultKey.usernameKey)
        preference?.set(token, forKey: DefaultKey.tokenKey)
        preference?.set(key, forKey: DefaultKey.dynamicKey)
        preference?.synchronize()
    }
    
    public func restoreLogin() -> [String] {
        var arrLogin:[String] = [String]()
        if let username = preference?.string(forKey: DefaultKey.usernameKey){
            arrLogin.append(username)
        }
        
        if let token = preference?.string(forKey: DefaultKey.tokenKey) {
            arrLogin.append(token)
        }
        
        if let dynamicKey = preference?.string(forKey: DefaultKey.dynamicKey){
            arrLogin.append(dynamicKey)
        }
        return arrLogin
    }
}
