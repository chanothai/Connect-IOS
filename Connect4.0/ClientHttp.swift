//
//  ClientHttp.swift
//  Connect4.0
//
//  Created by Pakgon on 5/11/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON
import AlamofireObjectMapper
import SwiftEventBus
import ObjectMapper

struct PathURL {
    static var urlServer = "connect06.pakgon.com/api/"
}

class ClientHttp {
    private let url:String?
    private static var me:ClientHttp?
    private var mySelf:BaseViewController?
    private let header: HTTPHeaders?
    
    init() {
        let https:String = "http://"
        self.url = "\(https)\(PathURL.urlServer)"
        
        let api = AuthenLogin().restoreLogin()
        let token = "Bearer \(api[0])"
        
        header = ["Authorization": token,"Accept-Language": "en;q=1.0", "Accept":"application/json", "Cache-Control": "no-cache, no-store, must-revalidate", "Pragma": "no-cache"]
        
    }
    
    public static func getInstace() -> ClientHttp {
        if me == nil {
            me = ClientHttp()
        }
        return me!
    }
    
    public func getUrl() -> String {
        return url!
    }
    
    public func getHeader() -> HTTPHeaders {
        return header!
    }
}
