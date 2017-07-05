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
import ObjectMapper

struct PathURL {
    static var urlServer = "connect01.pakgon.com/"
    
    static var apiRegister = "Api/registerUser.json"
    static var apiRegisterSecure = "Api/secure/registerUser.json"
    
    static var apiLogin = "Api/login.json"
    static var apiLoginSecure = "Api/secure/login.json"
    
    static var apiAuthToken = "Api/getOauthTokenFromUserToken.json"
    static var apiAuthSecure = "Api/secure/getOauthTokenFromUserToken.json"
    
    static var apiUserInfo = "Api/getUserInfo.json?authToken="
    
    static var apiVersion = "Api/version.json"
    static var currentVersion = "0.0.1"
    
    static var apiUserBloc = "Api/userAccessControl.json?authToken="
    
    static var apiVerifyUserSecure = "Api/secure/verifyUser.json"
    
    static var apiPersonalQuiz = "Api/checkTakeQuiz.json?authToken="
}

class ClientHttp {
    private let url:String?
    private static var me:ClientHttp?
    private var mySelf:BaseViewController?
    private let header: HTTPHeaders?
    
    init() {
        let https:String = "http://"
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
        let apiPath:String? = ("\(url!)\(PathURL.apiLoginSecure)")
        print("URL => \(apiPath!)")
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<LoginResponseSecure>) in
            
            guard let loginResponse = response.result.value else {
                print("Response was null")
                return
            }
            
            let data: String = (loginResponse.resultSecure?.eResult)!
            let decrypt = data.decryptData()
            print(decrypt)
            
            let decryptResponse = Mapper<LoginResponse>().map(JSONString: decrypt)
            if let token: String = decryptResponse?.result?.data?.user?.token {
                print("Token => " + token)
            }
            
            SwiftEventBus.post("ResponseLogin", sender: decryptResponse)
        }
    }
    
    public func requestRegister(_ jsonData: Dictionary<String, Any>) {
        let apiPath:String? = "\(url!)\(PathURL.apiRegisterSecure)"
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<RegisterResponseSecure>) in
            
            guard let registerResponse = response.result.value else {
                print("Response was null")
                print(response.error!)
                return
            }
            
            let data: String = (registerResponse.result?.eResult)!
            let decrypt: String = data.decryptData()
            print(decrypt)
            
            let decryptResponse = Mapper<RegisterResponse>().map(JSONString: decrypt)
            SwiftEventBus.post("ResponseRegister", sender: decryptResponse)
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
        
        Alamofire.request(realUrl, method: .get).responseObject(completionHandler: { (response: DataResponse<ResponseBloc>) in
            
            guard let resultResponse = response.result.value else {
                print("Bloc was null")
                return
            }
            
            print("Result => \(resultResponse)")
            if let success = resultResponse.resultBloc?.success {
                if success == "OK" {
                    SwiftEventBus.post("UserBlocResponse", sender: resultResponse.resultBloc?.dataBloc)
                }
            }
            
        })
    }
    
    public func verifyUser(_ verifyRequest: [String: Any]){
        let apiPath:String? = "\(url!)\(PathURL.apiVerifyUserSecure)"
        print(apiPath!)
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: verifyRequest, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<RegisterResponseSecure>) in
            
            guard let verifyResponse = response.result.value else {
                print("Response was null")
                return
            }
            
            let data: String = (verifyResponse.result?.eResult)!
            let decrypt = data.decryptData()
            print(decrypt)
            
            let decryptResponse = Mapper<VerifyResponse>().map(JSONString: decrypt)
            
            SwiftEventBus.post("ResponseVerify", sender: decryptResponse)
        }
    }
    
    public func requestQuiz(_ token: String){
        let path: String? = "\(url!)\(PathURL.apiPersonalQuiz)\(token)"
        print(path!)
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<QuizResponse>) in
            guard let responseQuiz = response.result.value else {
                print(response.error!)
                return
            }

            SwiftEventBus.post("ResponseQuiz", sender: responseQuiz.result)
        }
    }
}
