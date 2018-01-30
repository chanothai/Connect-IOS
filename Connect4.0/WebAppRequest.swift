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
    var url: String?
    
    init(url : String) {
        self.url = url
        guard let urlStr = URL(string: url) else {
            return
        }
        urlRequest = URLRequest(url: urlStr,cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,timeoutInterval: 10.0)
    }
    
    public func getUrlRequest(language: String, token: String) -> URLRequest{
        let result = "Bearer \(token)"
        urlRequest?.addValue("\(language);q=1.0", forHTTPHeaderField: "Accept-Language")
        urlRequest?.addValue(result, forHTTPHeaderField: "Authorization")
        
        return urlRequest!
    }
    
    public func getRequestWhenLink(request: URLRequest, language: String, token: String) -> URLRequest {
        var urlRequest = request
        urlRequest = URLRequest(url: URL(string: self.url!)!)
        let result = "Bearer \(token)"
        urlRequest.addValue("\(language);q=1.0", forHTTPHeaderField: "Accept-Language")
        urlRequest.addValue(result, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
