//
//  FormatterRequest.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class FormatterRequest {
    private var key:[UInt8]?
    private var resultJson:[String: String]?
    private var jsonData:[String: Any]?
    
    init(_ key: [UInt8]) {
        self.key = key
        resultJson = [String : String]()
        jsonData = [String : Any]()
    }
    
    public func loginSecure(_ parameter:[String : String]) -> [String: String]{
        jsonData?[LoginRequest.user] = parameter
        
        resultJson![LoginSecure.data] = convertToJson(jsonData!)
        return resultJson!
    }
    
    public func register(_ parameters:[String : String]) -> [String :String] {
        jsonData?[RegisterRequest.user] = parameters
        print(jsonData!)
        
        resultJson![RegisterSecure.data] = convertToJson(jsonData!)
        return resultJson!
    }
    
    public func verify(_ parameters:[String: String]) -> [String: String] {
        jsonData?[VerifyRequest.user] = parameters
        print(jsonData!)
        
        resultJson![VerifySecure.data] = convertToJson(jsonData!)
        return resultJson!
    }
    
    public func application(_ parameters:[String : Any], _ username:[String:String]) -> [String : Any]{
        var resultJson = [String:Any]()
        resultJson["Data"] = convertToJson(parameters)
        resultJson["User"] = ["username" : username]
        
        return resultJson
    }
    
    private func convertToJson(_ json:[String : Any]) -> String{
        let convertToJson = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let jsonString = String(data: convertToJson, encoding: .utf8)!
        let encrypt:String = try! EncryptionAES(key!).aesEncrypt(plainText: jsonString)
        print(encrypt)
        return encrypt
    }
}
