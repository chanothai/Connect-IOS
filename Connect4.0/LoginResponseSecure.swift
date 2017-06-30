//
//  LoginResponseSecure.swift
//  Connect4.0
//
//  Created by Pakgon on 6/27/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponseSecure: Mappable {
    var resultSecure: ResultSecure?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultSecure <- map["result"]
    }
}

class ResultSecure: Mappable {
    var success: String?
    var eResult: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        eResult <- map["EResult"]
    }
}
