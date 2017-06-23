//
//  ClientHttp.swift
//  Connect4.0
//
//  Created by Pakgon on 5/11/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON
import AlamofireObjectMapper
import SwiftEventBus

struct PathURL {
    static var urlServer = "connect01.pakgon.com/"
    
    static var apiRegister = "Api/registerUser.json"
    static var apiRegisterSecure = "Api/secure/registerUser.json"
    
    static var apiLogin = "ApiNotEncrypt/login.json"
    static var apiLoginSecure = "Api/login.json"
    
    static var apiAuthToken = "Api/getOauthTokenFromUserToken.json"
    static var apiAuthSecure = "Api/secure/getOauthTokenFromUserToken.json"
    
    static var apiUserInfo = "Api/getUserInfo.json?authToken="
    
    static var apiVersion = "Api/version.json"
    static var currentVersion = "0.0.1"
    
    static var apiUserBloc = "Api/getUserBlocs.json?authToken="
}

class ClientHttp {
    private let url:String?
    private static var me:ClientHttp?
    private var mySelf:BaseViewController?
    private let header: HTTPHeaders?
    
    init() {
        let https:String = "https://"
        self.url = "\(https)\(PathURL.urlServer)"
        
        header = ["Accept":"application/json"]
    }
    
    public static func getInstace() -> ClientHttp {
        if me == nil {
            me = ClientHttp()
        }
        return me!
    }
    
    public func checkVersion(){
        let apiPath:String? = ("\(url!)\(PathURL.apiVersion)")
        print(apiPath!)
        
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                FormatterResponse.parseJsonVersion(data: response.result.value! as AnyObject)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func requestLogin(_ jsonData: Dictionary<String, Any>){
        let apiPath:String? = ("\(url!)\(PathURL.apiLogin)")
        print("URL => \(apiPath!)")
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<LoginResponse>) in
            let loginResponse = response.result.value
            print("Result => \(String(describing: loginResponse?.result?.success))")
    
            SwiftEventBus.post("ResponseLogin", sender: loginResponse)
        }
    }
    
    public func requestRegister(_ jsonData: Dictionary<String, Any>) {
        let apiPath:String? = "\(url!)\(PathURL.apiRegisterSecure)"
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                FormatterResponse.parseJsonDataRegister(data: response.result.value as AnyObject)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func requestAuthToken(_ jsonData: [String: Any]) {
        let apiPath:String? = "\(url!)\(PathURL.apiAuthSecure)"
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                FormatterResponse.parseJsonAuthToken(data: response.result.value as AnyObject)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func requestUserInfo(_ authToken:String) {
        let apiPath:String? = "\(url!)\(PathURL.apiUserInfo)\(authToken)"
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                FormatterResponse.parseJsonUserInfo(data: response.result.value! as AnyObject)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func requestUserBloc(_ authToken:String) {
        let apiPath:String? = "\(url!)\(PathURL.apiUserBloc)\(authToken)"
        print(apiPath!)
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                FormatterResponse.parseJsonUserBloc(data: response.result.value! as AnyObject)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}
