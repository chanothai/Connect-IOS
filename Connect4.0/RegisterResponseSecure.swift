//
//  RegisterResponseSecure.swift
//  Connect4.0
//
//  Created by Pakgon on 6/29/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterResponseSecure: Mappable {
    var result: RegisterSecureResult?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class RegisterSecureResult: Mappable {
    var success: String?
    var eResult: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        eResult <- map["EResult"]
    }
}
