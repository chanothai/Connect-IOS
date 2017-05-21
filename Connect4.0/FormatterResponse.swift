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
            result.success = success
            
            if success.isEmpty {
                let error:String = (jsonEResult!["Error"] as? String)!
                result.error = error
            }
            
            loginResponse.result = result
            SwiftEventBus.post("ResponseLogin", sender: loginResponse)
        }
    }
    
    public static func parseJsonDataRegister(data: AnyObject) {
        let jsonResult = data as? NSDictionary
        print(jsonResult as AnyObject)
        
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
}

extension String {
    func decryptData() -> String {
        let splitStr = self.components(separatedBy: KeyName.byteIVStr)
        let iv = [UInt8](Data(base64Encoded: splitStr[1], options: Data.Base64DecodingOptions(rawValue: 0))!)
        let decrypt = try! EncryptionAES(RequireKey.key).aesDecrypt(plainText: splitStr[0], iv: iv)
        print(decrypt)
        
        return decrypt
    }
}
