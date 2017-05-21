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
    static let passwordKey = "password_key"
    static let encryptionKey = "encryption_key"
}
class AuthenLogin {
    private var preference: UserDefaults?
    
    init() {
        preference = UserDefaults.standard
    }
    
    public func storeLogin(_ username:String, _ password:String, _ key:String) {
        preference?.set(username, forKey: DefaultKey.usernameKey)
        preference?.set(password, forKey: DefaultKey.passwordKey)
        preference?.set(key, forKey: DefaultKey.encryptionKey)
        preference?.synchronize()
    }
    
    public func restoreLogin() -> [String] {
        var arrLogin:[String] = [String]()
        if let username = preference?.string(forKey: DefaultKey.usernameKey){
            arrLogin.append(username)
        }
        
        if let password = preference?.string(forKey: DefaultKey.passwordKey) {
            arrLogin.append(password)
        }
        
        //clear preference
//        if let bundle = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundle)
//        }
        
        return arrLogin
    }
}
