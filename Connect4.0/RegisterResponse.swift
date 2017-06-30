//
//  RegisterResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 6/29/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterResponse: Mappable {
    var result: RegisterResult?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class RegisterResult: Mappable {
    var success: String?
    var eResult: EResultRegister?
    var error: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        eResult <- map["EResult"]
        error <- map["Error"]
    }
}

class EResultRegister: Mappable {
    var message: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["Message"]
    }
}

struct RegisterRequest {
    static var user:String = "User"
}

struct UserRegister {
    static var citizenID:String = "citizen_id"
    static var firstName:String = "first_name"
    static var lastName:String = "last_name"
    static var screenName:String = "screen_name"
    static var birthDate:String = "birth_date"
    static var phone:String = "phone_no"
    static var username:String = "username"
    static var email: String = "email"
    static var password:String = "password"
    static var rePassword:String = "re_password"
}

struct RegisterSecure {
    static var data:String = "Data"
}

