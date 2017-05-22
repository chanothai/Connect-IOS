//
//  UserInfoResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 5/22/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class UserInfoResponse {
    private var _birthDate:String?
    private var _citizenID:String?
    private var _firstName:String?
    private var _lastName:String?
    private var _screenName:String?
    private var _phone:String?
    private var _username:String?
    private var _profile_image_path:String?
    private var _created:String?
    private var _modified:String?
    
    var birthDate:String {
        get{
            return _birthDate!
        }
        set {
            _birthDate = newValue
        }
    }
    
    var citizenID:String {
        get{
            return _citizenID!
        }
        set {
            _citizenID = newValue
        }
    }
    
    var firstName:String {
        get{
            return _firstName!
        }
        set {
            _firstName = newValue
        }
    }
    
    var lastName:String {
        get{
            return _lastName!
        }
        set {
            _lastName = newValue
        }
    }
    
    var screenName:String {
        get{
            return _screenName!
        }
        set {
            _screenName = newValue
        }
    }
    
    var phone:String {
        get{
            return _phone!
        }
        set {
            _phone = newValue
        }
    }
    
    var username:String {
        get{
            return _username!
        }
        set {
            _username = newValue
        }
    }
    
    var profile_image_path:String {
        get{
            return _profile_image_path!
        }
        set {
            _profile_image_path = newValue
        }
    }
    
    var created:String {
        get{
            return _created!
        }
        set {
            _created = newValue
        }
    }
    
    var modified:String {
        get{
            return _modified!
        }
        set {
            _modified = newValue
        }
    }
}
