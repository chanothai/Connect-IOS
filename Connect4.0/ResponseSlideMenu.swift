//
//  ResponseSlideMenu.swift
//  Connect4.0
//
//  Created by Pakgon on 11/9/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON
import SwiftEventBus
import Alamofire
import AlamofireImage

class ResponseSlideMenu: Mappable {
    var status: String?
    var result: ResultSlideMenu?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}

class ResultSlideMenu: Mappable {
    var error: String?
    var data: DataSlideMenu?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["Data"]
        error <- map["error"]
    }
}

class DataSlideMenu: Mappable {
    var menus: [MenusSlide]?
    var languages: [LanguageSlideMenu]?
    var profiles: UserProfile?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        languages <- map["Languages"]
        menus <- map["Menus"]
        profiles <- map["Profiles"]
    }
}

class MenusSlide: Mappable {
    var label: String?
    var url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        label <- map["label"]
        url <- map["url"]
    }
}

class LanguageSlideMenu: Mappable {
    var languageDesc: String?
    var languageTH: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        languageDesc <- map["code"]
        languageTH <- map["value"]
    }
}

class UserProfile: Mappable {
    var firstName: String?
    var lastName: String?
    var gender: String?
    var imgPath: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        firstName <- map["firstname"]
        lastName <- map["lastname"]
        gender <- map["gender"]
        imgPath <- map["img_path"]
    }
}

class SlideMenuRequest {
    func request() {
        let path: String = "\(ClientHttp.getInstace().getUrl())Profiles"
//        let path: String = "\(ClientHttp.getInstace().getUrl())Connects/language"
        print(path)
        guard let url = URL(string: path) else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ClientHttp.getInstace().getHeader()).responseObject { (response: DataResponse<ResponseSlideMenu>) in
            
            guard let response = response.result.value else {
                print("Response was null")
                return
            }
            
            SwiftEventBus.post("ResponseSlideMenu", sender: response)
        }
    }
}

class ModelSlideMenu {
    var _result: ResultSlideMenu?
    var result: ResultSlideMenu {
        get{
            return _result!
        }
        set {
            _result = newValue
        }
    }
}

