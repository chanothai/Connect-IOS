//
//  LocationModel.swift
//  Connect4.0
//
//  Created by Pakgon on 11/13/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class LocationModel {
    var _lat: String?
    
    var lat: String? {
        get {
            return _lat!
        }
        set {
            _lat = newValue
        }
    }
    
    var _long:String?
    var long: String? {
        get{
            return _long!
        }
        
        set{
            _long = newValue
        }
    }
}
