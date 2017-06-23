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

    }
    
    public static func parseJsonDataRegister(data: AnyObject) {
        
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
    
    public static func parseJsonVersion(data: AnyObject){
        let jsonResult = data as? NSDictionary
        
        let result = jsonResult?["result"] as AnyObject
        let success:String = (result["Success"] as? String)!
        let data = result["Data"] as AnyObject
        let newVersion = (data["version"] as? String)!
        
        if success == "OK" {
            if newVersion == PathURL.currentVersion {
                SwiftEventBus.post("CheckVersion")
            }
        }
    }
    
    public static func parseJsonUserBloc(data: AnyObject) {
        let jsonResult = data as? NSDictionary
        
        let result = jsonResult?["result"] as AnyObject
        guard let success:String = result["Success"] as? String else {
            let error:String = (result["Error"] as? String)!
            print(error)
            return
        }
        
        if success == "OK" {
            let datas = result["Data"] as? [[String: Any]]
            
            var resultResponse = [ResultCategory]()
            var resultCategory = ResultCategory()
            
            for i in 0 ..< (datas?.count)! {
                let blocCategory = datas?[i]["BlocCategory"] as AnyObject
                var categoryModel = BlocCategoryResponse()
                categoryModel.id = (blocCategory["id"] as? Int)!
                categoryModel.bloc_category_name = (blocCategory["bloc_category_name"] as? String)!
                categoryModel.sort_order = (blocCategory["sort_order"] as? Int)!
                categoryModel.bloc_category_image_path = (blocCategory["bloc_category_image_path"] as? String)!
                
                if let created = blocCategory["created"] as? String {
                    categoryModel.created = created
                }
    
                if let modify = blocCategory["modified"] as? String {
                    categoryModel.modified = modify
                }
                
                resultCategory.resultCategory = categoryModel
                
                var arrBloc = [Bloc]()
                let bloc = datas?[i]["Bloc"] as! [[String: Any]]
                for j in 0 ..< bloc.count {
                    var blocModel = Bloc()
                    blocModel.id = (bloc[j]["id"] as? Int)!
                    blocModel.bloc_name = (bloc[j]["bloc_name"] as? String)!
                    if let description = bloc[j]["bloc_description"] as? String {
                        blocModel.bloc_description = description
                    }
                    blocModel.bloc_owner_id = (bloc[j]["bloc_owner_id"] as? Int)!
                    blocModel.bloc_url = (bloc[j]["bloc_url"] as? String)!
                    if let iconPath = bloc[j]["bloc_icon_path"] as? String {
                        blocModel.bloc_icon_path = iconPath
                    }
                    
                    if let img1 = bloc[j]["bloc_image1_path"] as? String {
                        blocModel.bloc_image1_path = img1
                    }
                    
                    if let img2 = bloc[j]["bloc_image2_path"] as? String {
                        blocModel.bloc_image2_path = img2
                    }
                    
                    if let img3 = bloc[j]["bloc_image3_path"] as? String {
                        blocModel.bloc_image3_path = img3
                    }
                
                    blocModel.bloc_category_id = (bloc[j]["bloc_category_id"] as? Int)!
                    
                    if let created = bloc[j]["created"] as? String {
                        blocModel.created = created

                    }
                    if let modified = bloc[j]["modified"] as? String  {
                        blocModel.modified = modified
                    }
                    
                    arrBloc.append(blocModel)
                    resultCategory.resultBloc = arrBloc
                }
                
                resultResponse.append(resultCategory)
                print(resultResponse)
            }
            
            SwiftEventBus.post("UserBlocResponse", sender: resultResponse)
        }else{
            
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
