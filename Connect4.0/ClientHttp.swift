//
//  ClientHttp.swift
//  Connect4.0
//
//  Created by Pakgon on 5/11/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import SwiftEventBus
import Alamofire
import UIKit

struct PathURL {
    var urlServer = "http://api.psp.pakgon.com/"
    var apiRegister = "Api/registerUser.json"
    var apiLogin = "Api/login.json"
}

class ClientHttp {
    private let url:String?
    private static var me:ClientHttp?
    private var mySelf:BaseViewController?
    private let header: HTTPHeaders?
    
    init(_ mySelf:BaseViewController) {
        self.url = PathURL().urlServer
        self.mySelf = mySelf
        
        header = ["Accept":"application/json"]
    }
    
    public static func getInstace(_ mySelf: BaseViewController) -> ClientHttp {
        if me == nil {
            me = ClientHttp(mySelf)
        }
        return me!
    }
    
    public func requestLogin(_ jsonData: Dictionary<String, Any>){
        let apiPath:String? = ("\(url!)\(PathURL().apiLogin)")
        print(apiPath!)
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in

            switch response.result {
            case .success:
                self.parseJsonDataLogin(data: response.result.value as AnyObject)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func parseJsonDataLogin(data: AnyObject) {
        let jsonResult = data as? NSDictionary
        print(jsonResult as AnyObject)
        
        // Parse JSON data
        let jsonResponse = jsonResult?["result"] as AnyObject
        let success:String = (jsonResponse["Success"] as? String)!
        
        var loginResponse:LoginResponse = LoginResponse()
        var result:LoginResult = LoginResult()
        result.success = success
        
        if success.isEmpty {
            let error:String = (jsonResponse["Error"] as? String)!
            result.error = error
        }
        
        loginResponse.result = result
        SwiftEventBus.post("ResponseLogin", sender: loginResponse)
    }
    
    public func requestRegister(_ jsonData: Dictionary<String, Any>) {
        let apiPath:String? = "\(url!)\(PathURL().apiRegister)"
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                self.parseJsonDataRegister(data: response.result.value as AnyObject)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func parseJsonDataRegister(data: AnyObject) {
        let jsonResult = data as? NSDictionary
        print(jsonResult as AnyObject)
        
        // Parse JSON data
        let jsonResponse = jsonResult?["result"] as AnyObject
        let success:String = (jsonResponse["Success"] as? String)!
        
        var loginResponse:LoginResponse = LoginResponse()
        var result:LoginResult = LoginResult()
        result.success = success
        
        if success.isEmpty {
            let error:String = (jsonResponse["Error"] as? String)!
            result.error = error
        }
        
        loginResponse.result = result
        SwiftEventBus.post("ResponseRegister", sender: loginResponse)
    }
    
}
