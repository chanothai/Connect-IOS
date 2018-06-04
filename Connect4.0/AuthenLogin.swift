//
//  ValidateLogin.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

struct DefaultKey {
    static let webKey = "web_key"
    static let tokenKey = "token_key"
    static let subscriptKey = "subscribe_key"
}

class AuthenLogin {
    private var preference: UserDefaults?
    
    init() {
        preference = UserDefaults.standard
    }
    
    public func storeLogin(_ token:String, _ web:String, _ subscribe: String) {
        preference?.set(token, forKey: DefaultKey.tokenKey)
        preference?.set(web, forKey: DefaultKey.webKey)
        preference?.set(subscribe, forKey: DefaultKey.subscriptKey)
        preference?.synchronize()
    }
    
    public func restoreLogin() -> [String] {
        var arrLogin:[String] = [String]()
        if let token = preference?.string(forKey: DefaultKey.tokenKey) {
            arrLogin.append(token)
        }
        
        if let web = preference?.string(forKey: DefaultKey.webKey){
            arrLogin.append(web)
        }
        
        if let sub = preference?.string(forKey: DefaultKey.subscriptKey){
            arrLogin.append(sub)
        }
        
        return arrLogin
    }
}
