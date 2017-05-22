//
//  ApplicationResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 5/22/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class ApplicationResponse {
    private var _result:AuthToken?
    private var _success:String?
    
    public var result:AuthToken {
        get {
            return _result!
        }
        set{
            _result = newValue
        }
    }
    
    public var success:String {
        get {
            return _success!
        }
        set{
            _success = newValue
        }
    }
}

class AuthToken {
    private var _authToken:String?
    private var _expire:String?
    
    public var authToken:String {
        get {
            return _authToken!
        }
        set {
            _authToken = newValue
        }
    }
    
    public var expire:String {
        get {
            return _expire!
        }
        set {
            _expire = newValue
        }
    }
}
