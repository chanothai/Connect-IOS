//
//  LoginResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 5/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

struct LoginResponse {
    private var _result:LoginResult?
    
    public var result:LoginResult {
        get{
            return _result!
        }
        set{
            _result = newValue
        }
    }
}

struct LoginResult {
    private var _error:String?
    private var _success:String?
    
    public var error:String {
        get{
            return _error!
        }
        set{
            _error = newValue
        }
    }
    
    public var success:String {
        get{
            return _success!
        }
        set{
            _success = newValue
        }
    }
}
