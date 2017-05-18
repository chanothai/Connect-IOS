//
//  ClientHttp.swift
//  Connect4.0
//
//  Created by Pakgon on 5/11/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Alamofire
import UIKit

struct PathURL {
    var urlServer = "http://api.psp.pakgon.com/Api/"
    var apiRegister = "registerUser.json"
}
class ClientHttp {
    private let url:String?
    private static var me:ClientHttp?
    
    init() {
        self.url = PathURL().urlServer
    }
    
    public static func getInstace() -> ClientHttp {
        if me == nil {
            me = ClientHttp()
        }
        return me!
    }
    
    func requestRequest(_ jsonData: Dictionary<String, Any>) {
        let apiPath:String? = PathURL().apiRegister
        guard let realUrl = URL(string: url!+apiPath!) else {
            return
        }
        
        let header: HTTPHeaders = ["Accept":"application/json"]
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            (response) -> Void in
            switch response.result {
            case .success:
                self.parseJsonData(data: response.result.value as AnyObject)
                break
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func parseJsonData(data: AnyObject) {
        var response:RegisterResponse = RegisterResponse()
        
        let jsonResult = data as? NSDictionary
        print(jsonResult as AnyObject)
        
        // Parse JSON data
        let jsonResponse = jsonResult?["result"] as AnyObject
        let success:String = (jsonResponse["Success"] as? String)!
        
        if success.isEmpty {
            let error:String = jsonResponse["Error"] as! String
            print(error)
        }else{
            print("Value : \(success)")
            response.result?.Success = success
        }
    }
    
    
}
