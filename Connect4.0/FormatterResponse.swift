//
//  FormatterResponse.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import CryptoSwift
import SwiftEventBus

class FormatterResponse {
    
    public static func parseJsonDataLogin(data: AnyObject) {
        let jsonResult = data as? NSDictionary
        print(jsonResult as AnyObject)
        
        // Parse JSON data
        let jsonResponse = jsonResult?["result"] as AnyObject
        let validate:String = (jsonResponse["Success"] as? String)!
        let eResult:String = (jsonResponse["EResult"] as? String)!
        let decrypt = eResult.decryptData()
        
        if validate == "OK" {
            let jsonEResult = try! JSONSerialization.jsonObject(with: decrypt.data(using: .utf8)!, options: []) as? [String : Any]
            let success:String = (jsonEResult!["Success"] as? String)!
            
            var loginResponse:LoginResponse = LoginResponse()
            var result:LoginResult = LoginResult()

            if success.isEmpty {
                let error:String = (jsonEResult!["Error"] as? String)!
                result.error = error
                result.success = success
            }else{
                let jsonData = jsonEResult?["Data"] as AnyObject
                let jsonUser = jsonData["User"] as AnyObject
                let dynamicKey = jsonUser["dynamic_key"] as? String
                let token = jsonUser["token"] as? String
                
                result.success = success
                result.dynamicKey = dynamicKey!
                result.token = token!

            }
            
            loginResponse.result = result
            SwiftEventBus.post("ResponseLogin", sender: loginResponse)
        }
    }
    
    public static func parseJsonDataRegister(data: AnyObject) {
        let jsonResult = data as? NSDictionary
        print(data)
        
        // Parse JSON data
        let jsonResponse = jsonResult?["result"] as AnyObject
        let validate:String = (jsonResponse["Success"] as? String)!
        let eResult:String = (jsonResponse["EResult"] as? String)!
        let decrypt = eResult.decryptData()
        print(decrypt)
        
        if validate == "OK" {
            let jsonEResult = try! JSONSerialization.jsonObject(with: decrypt.data(using: .utf8)!, options: []) as? [String : Any]
            let success:String = (jsonEResult!["Success"] as? String)!
            
            var loginResponse:LoginResponse = LoginResponse()
            var result:LoginResult = LoginResult()
            result.success = success
            
            if success.isEmpty {
                let error:String = (jsonEResult!["Error"] as? String)!
                result.error = error
            }
            
            loginResponse.result = result
            SwiftEventBus.post("ResponseRegister", sender: loginResponse)
        }
    }
    
    public static func parseJsonAuthToken(data: AnyObject){
        let jsonResult = data as? NSDictionary
        print(data)
        
        // Parse json data
        let jsonResponse = jsonResult?["result"] as AnyObject
        let validate:String = (jsonResponse["Success"] as? String)!
        let eResult:String = (jsonResponse["EResult"] as? String)!
        let decrypt = eResult.decryptData()
        print(decrypt)
        
        if validate == "OK" {
            let jsonEResult = try! JSONSerialization.jsonObject(with: decrypt.data(using: .utf8)!, options: []) as? [String : Any]
            
            let jsonAuthToken = jsonEResult?["AuthToken"] as AnyObject
            let authToken:String = (jsonAuthToken["auth_token"] as? String)!
            let authTokenExpire:String = (jsonAuthToken["auth_token_expiry_date"] as? String)!
            
            let result = ApplicationResponse()
            let auth = AuthToken()
            auth.authToken = authToken
            auth.expire = authTokenExpire
            
            result.result = auth
            result.success = validate
            
            SwiftEventBus.post("ResponseApplication", sender: result)
        }
    }
    
    public static func parseJsonUserInfo(data: AnyObject){
        let jsonResult = data as? NSDictionary
        
        let result = jsonResult?["result"] as AnyObject
        let success:String = (result["Success"] as? String)!
        
        if success == "OK" {
            let data = result["Data"] as AnyObject
            let user = data["User"] as AnyObject
            
            let userInfo = UserInfoResponse()
            userInfo.birthDate = (user["birth_date"] as? String)!
            userInfo.firstName = (user["first_name"] as? String)!
            userInfo.lastName = (user["last_name"] as? String)!
            userInfo.screenName = (user["screen_name"] as? String)!
            userInfo.username = (user["username"] as? String)!
            userInfo.phone = (user["phone"] as? String)!
            userInfo.citizenID = (user["citizen_id"] as? String)!
            userInfo.profile_image_path = (user["profile_image_path"] as? String)!
            userInfo.created = (user["created"] as? String)!
            userInfo.modified = (user["modified"] as? String)!
            
            SwiftEventBus.post("UserInfoResponse", sender: userInfo)
        }
    }
}

extension String {
    func decryptData() -> String {
        let splitStr = self.components(separatedBy: KeyName.byteIVStr)
        let iv = [UInt8](Data(base64Encoded: splitStr[1], options: Data.Base64DecodingOptions(rawValue: 0))!)
        let decrypt = try! EncryptionAES(RequireKey.key).aesDecrypt(plainText: splitStr[0], iv: iv)
        return decrypt
    }
}
