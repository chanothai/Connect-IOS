//
//  EncryptionAES.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import CryptoSwift

struct KeyName {
    static var staticKey = "APuT9Gt43aGNLUwn+ewtjzV+1cXjdLcSe/TYXf7n8Vs="
    static var byteIVStr = "ByteIV"
}

struct RequireKey {
    private static var _key:[UInt8]?
    
    public static var key:[UInt8]{
        get{
            return _key!
        }
        set{
            _key = newValue
        }
    }
}

class EncryptionAES {
    private var key:[UInt8]?
    init(_ key:[UInt8]) {
        self.key = key
    }
    
    func aesEncrypt(plainText:String) throws -> String {
        let iv = AES.randomIV(AES.blockSize)
        let data = plainText.data(using: .utf8)!
        let encrypted = try! AES(key: key!, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        
        let ivEncode = Data(iv).base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return encryptedData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) + KeyName.byteIVStr + ivEncode
    }
    
    func aesDecrypt(plainText:String, iv:[UInt8]) throws -> String {
        let data = Data(base64Encoded: plainText, options: Data.Base64DecodingOptions(rawValue: 0))!
        let decrypted = try! AES(key: key!, iv: iv, blockMode: .CBC, padding: ZeroPadding()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}
