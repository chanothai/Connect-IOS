//
//  LoginResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 5/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: Mappable {
    var result: LoginResult?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class LoginResult: Mappable {
    var success: String?
    var error: String?
    var Eresult: LoginEResult?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        error <- map["Error"]
        Eresult <- map["EResult"]
    }
}

class LoginEResult: Mappable {
    var user: LoginUser?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user <- map["User"]
    }
}

class LoginUser: Mappable {
    var dynamicKey: String?
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dynamicKey <- map["dynamic_key"]
        token <- map["token"]
    }
}
