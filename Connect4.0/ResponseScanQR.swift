//
//  ResponseScanQR.swift
//  Connect4.0
//
//  Created by Pakgon on 23/11/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import SwiftEventBus

class ResponseScanQR: Mappable {
    var status: String?
    var result: ResultScanQR?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}

class ResultScanQR: Mappable {
    var data: DataScanQR?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["Data"]
    }
}

class DataScanQR: Mappable {
    var url: String?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        message <- map["message"]
    }
}

class RequestScanQR {
    func request(parameter: [String: String]) {
        let path = "\(ClientHttp.getInstace().getUrl())Barcodes/verify"
        print(path)
        guard let url = URL(string: path) else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: ClientHttp.getInstace().getHeader()).responseObject { (response:DataResponse<ResponseScanQR>) in
            
            guard let result = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("ResponseScanQR", sender: result)
        }
    }
}

class StoreUrl {
    var _url: String?
    var url: String? {
        get {
            return _url!
        }
        
        set{
            _url = newValue
        }
    }
}
