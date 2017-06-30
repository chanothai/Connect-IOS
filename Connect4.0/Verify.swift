//
//  VerifyResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 6/30/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class VerifyResponse: Mappable {
    var result: ResultVerify?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class ResultVerify: Mappable {
    var success: String?
    var error: String?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        error <- map["Error"]
        message <- map["Message"]
    }
}

struct VerifyRequest {
    static var user: String = "User"
}

struct UserVerify {
    static var username: String = "username"
    static var pinCode: String = "pin_code"
}

struct VerifySecure {
    static var data: String = "Data"
}
