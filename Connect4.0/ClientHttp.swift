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
    static var urlServer = "http://api.psp.pakgon.com/"
    static var apiRegister = "Api/registerUser.json"
    static var apiRegisterSecure = "Api/secure/registerUser.json"
    static var apiLogin = "Api/login.json"
    static var apiLoginSecure = "Api/secure/login.json"
}

class ClientHttp {
    private let url:String?
    private static var me:ClientHttp?
    private var mySelf:BaseViewController?
    private let header: HTTPHeaders?
    
    init(_ mySelf:BaseViewController) {
        self.url = PathURL.urlServer
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
        let apiPath:String? = ("\(url!)\(PathURL.apiLoginSecure)")
        print(apiPath!)
        guard let realUrl = URL(string: apiPath!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            switch response.result {
            case .success:
                FormatterResponse.parseJsonDataLogin(data: response.result.value as AnyObject)
                break
            case .failure(let error):
                print(error)
            }
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
}
