//
//  ContactResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 7/7/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactResponse: Mappable {
    var result: ResultContact?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class ResultContact: Mappable {
    var success: String?
    var error: String?
    var data: [UserPersonal]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        error <- map["Error"]
        data <- map["Data"]
    }
}

class UserPersonal: Mappable {
    var userID: Int?
    var firstNameTH: String?
    var lastNameTH: String?
    var firstNameEN: String?
    var lastNameEN: String?
    var mobile: String?
    var phone: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userID <- map["user_id"]
        firstNameTH <- map["firstname_th"]
        lastNameTH <- map["lastname_th"]
        firstNameEN <- map["firstname_en"]
        lastNameEN <- map["lastname_en"]
        mobile <- map["mobile_no"]
        phone <- map["phone_no"]
    }
}
