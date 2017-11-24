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
    
    private func convertToJson(_ json:[String : Any]) -> String{
        let convertToJson = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let jsonString = String(data: convertToJson, encoding: .utf8)!
        let encrypt:String = try! EncryptionAES(key!).aesEncrypt(plainText: jsonString)
        print(encrypt)
        return encrypt
    }
}
