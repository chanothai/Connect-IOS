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
import AlamofireLogger

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
    var languages: LanguageSlideMenu?
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
    var title: String?
    var listLanguage: [ListLanguage]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["label"]
        listLanguage <- map["list"]
    }
}

class ListLanguage: Mappable {
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
    func request(_ parameter: [String: String]) {
        let path: String = "\(ClientHttp.getInstace().getUrl())Profiles/info"
        print(path)
        guard let url = URL(string: path) else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: ClientHttp.getInstace().getHeaderOriginal()).logRequest(.verbose).logResponse(.simple).responseObject { (response: DataResponse<ResponseSlideMenu>) in
            
            guard let responses = response.result.value else {
                print(response)
                print("Response was null")
                return
            }
            
            let menu = responses.toJSONString()
            
            print("Response: \(menu ?? "Null ")")
            SwiftEventBus.post("ResponseSlideMenu", sender: responses)
        }
    }
    
    func requestNonParameter() {
        let path: String = "\(ClientHttp.getInstace().getUrl())Profiles/info"
        //        let path: String = "\(ClientHttp.getInstace().getUrl())Connects/language"
        print(path)
        guard let url = URL(string: path) else {
            return
        }
        
        let langStr = Locale.current.languageCode
        let regionCode = Locale.current.regionCode
        let result = "\(langStr!)-\(regionCode!),\(langStr!);q=1.0"
        print("Result: \(result)")
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ClientHttp.getInstace().getHeader(language: result)).logRequest(.verbose).logResponse(.simple).responseObject { (response: DataResponse<ResponseSlideMenu>) in
            
            guard let responses = response.result.value else {
                print(response)
                print("Response was null")
                return
            }
            
            SwiftEventBus.post("ResponseSlideMenu", sender: responses)
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

