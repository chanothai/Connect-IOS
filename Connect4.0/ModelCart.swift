//
//  ModelCart.swift
//  Connect4.0
//
//  Created by Pakgon on 5/22/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelCart {
    private static var me:ModelCart?
    var modelSlideMenu: ModelSlideMenu?
    var location: LocationModel?
    var storeUrl: StoreUrl?
    
    init() {
        modelSlideMenu = ModelSlideMenu()
        location = LocationModel()
        location?.lat = ""
        location?.long = ""
        
        storeUrl = StoreUrl()
        storeUrl?.url = ""
    }
    
    public static func getInstance() -> ModelCart {
        if me == nil {
            me = ModelCart()
        }
        
        return me!
    }
    
    public func getModelSlideMenu() -> ModelSlideMenu {
        return modelSlideMenu!
    }
    
    public func getLocation() -> LocationModel {
        return location!
    }
    
    public func getStoreUrl() -> StoreUrl {
        return storeUrl!
    }
}
