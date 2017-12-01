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
    private var token: String?
    
    init() {
        let https:String = "http://"
        self.url = "\(https)\(PathURL.urlServer)"
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
    
    public func getHeaderOriginal() -> HTTPHeaders {
        let header = ["Authorization": token!, "Accept":"application/json", "Cache-Control": "no-cache, no-store, must-revalidate", "Pragma": "no-cache"]
        return header
    }
    
    public func getHeader(language: String) -> HTTPHeaders {
        let api = AuthenLogin().restoreLogin()
        token = "Bearer \(api[0])"
        
        let header = ["Authorization": token!,"Accept-Language": language, "Accept":"application/json", "Cache-Control": "no-cache, no-store, must-revalidate", "Pragma": "no-cache"]
        return header
    }
}
