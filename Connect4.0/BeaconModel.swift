//
//  BeaconModel.swift
//  Connect4.0
//
//  Created by Macintosh on 26/1/18.
//  Copyright © 2018 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

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

class Beacon: Mappable {
    var device:String?
    var distance: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        device <- map["device"]
        distance <- map["distance"]
    }
}

class StoreBeacon {
    var _listBeacon: [[String: String]]?
    var listBeacon: [[String: String]] {
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
        listBeacon?.listBeacon = [[String: String]]()
    }
    
    static func getInstance() -> NearbyManager {
        if nearby == nil {
            nearby = NearbyManager()
        }
        
        return nearby!
    }
    
    func setlistBeacon(model: [String: String]) {
        listBeacon?.listBeacon.append(model)
    }
    
    func getListBeacon() -> [[String: String]] {
        return (listBeacon?.listBeacon)!
    }
    
    func updateListBeacon(arrBeacon: [[String: String]]) {
        listBeacon?.listBeacon = arrBeacon
    }
    
    func convertModel(model: [[String: String]]) -> String {
        let data = try? JSONSerialization.data(withJSONObject: model, options: [])
        let json = String(data: data!, encoding: .utf8)
        
        return json!
    }
}
