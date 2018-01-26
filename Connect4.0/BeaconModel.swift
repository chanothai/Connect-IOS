//
//  BeaconModel.swift
//  Connect4.0
//
//  Created by Macintosh on 26/1/18.
//  Copyright © 2018 Pakgon. All rights reserved.
//

import Foundation

class BeaconModel {
    var _device: String?
    var device: String {
        get{
            return _device!
        }
        set {
            _device = newValue
        }
    }
    
    var _distance: String?
    var distance: String {
        get{
            return _distance!
        }
        set {
            _distance = newValue
        }
    }
    
    var _rsi: String?
    var rsi: String {
        get{
            return _rsi!
        }
        set {
            _rsi = newValue
        }
    }
}

class StoreBeacon {
    var _listBeacon: [BeaconModel]?
    var listBeacon: [BeaconModel] {
        get {
            return _listBeacon!
        }
        set {
            _listBeacon = newValue
        }
    }
}

public class NearbyManager {
    static var nearby:NearbyManager? = nil
    var listBeacon: StoreBeacon?
    
    init() {
        listBeacon = StoreBeacon()
        let model = BeaconModel()
        model.device = ""
        listBeacon?.listBeacon = [model]
    }
    
    static func getInstance() -> NearbyManager {
        if nearby == nil {
            nearby = NearbyManager()
        }
        
        return nearby!
    }
    
    func getListBeacon() -> StoreBeacon {
        return listBeacon!
    }
}
