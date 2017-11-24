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
    
}

extension String {
    func decryptData() -> String {
        
        let splitStr = self.components(separatedBy: KeyName.byteIVStr)
        let iv = [UInt8](Data(base64Encoded: splitStr[1], options: Data.Base64DecodingOptions(rawValue: 0))!)
        let decrypt = try! EncryptionAES(RequireKey.key).aesDecrypt(plainText: splitStr[0], iv: iv)
        return decrypt
    }
}
