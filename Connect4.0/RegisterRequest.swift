//
//  RegisterRequest.swift
//  Connect4.0
//
//  Created by Pakgon on 5/11/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

struct RegisterRequest: JSONSerializable{
    var User:User
}

struct User: JSONSerializable {
    var citizen_id:String
    var first_name:String
    var last_name:String
    var screen_name:String
    var birth_date:String
    var phone:String
    var password:String
    var re_password:String
}
