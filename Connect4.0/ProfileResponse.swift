//
//  ProfileResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 7/6/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileResponse: Mappable {
    var result: ProfileResult?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class ProfileResult: Mappable {
    var success: String?
    var profileData: [ProfileData]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        profileData <- map["ProfileData"]
    }
}

class ProfileData: Mappable {
    var profileID: Int?
    var personCard: String?
    var firstNameTH: String?
    var lastNameTH: String?
    var firstNameEN: String?
    var lastNameEN: String?
    var mobileNo: String?
    var email: String?
    var section: String?
    var department: String?
    var organization: String?
    var imgPath: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        profileID <- map["profile_id"]
        personCard <- map["person_card_no"]
        firstNameTH <- map["firstname_th"]
        lastNameTH <- map["lastname_th"]
        firstNameEN <- map["firstname_en"]
        lastNameEN <- map["lastname_en"]
        mobileNo <- map["moblie_no"]
        email <- map["email"]
        section <- map["section"]
        department <- map["department"]
        organization <- map["organization"]
        imgPath <- map["img_path"]
    }
}

