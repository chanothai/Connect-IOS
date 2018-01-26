//
//  WebAppRequest.swift
//  Connect4.0
//
//  Created by Pakgon on 11/14/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class WebAppRequest {
    private static var me: WebAppRequest?
    var urlRequest: URLRequest?
    
    init(url : String) {
        guard let url = URL(string: url) else {
            return
        }
        urlRequest = URLRequest(url: url,cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,timeoutInterval: 10.0)
    }
    
    public func getUrlRequest(language: String, token: String) -> URLRequest{
        let result = "Bearer \(token)"
        urlRequest?.addValue("\(language);q=1.0", forHTTPHeaderField: "Accept-Language")
        urlRequest?.addValue(result, forHTTPHeaderField: "Authorization")
        
        return urlRequest!
    }
}
