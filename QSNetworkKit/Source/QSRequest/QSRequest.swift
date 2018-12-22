//
//  QSRequest.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/20.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation


struct QSRequest: QSRequestFormat {
    
    func asURLRequest() throws -> URLRequest {
        let request = try URLRequest(url: url, method: method, headers: headers)
        return try encoding.encode(request, with: parameters)
    }
    
    let url: QSURLFormat
    let method: QSHTTPMethod
    let parameters: Parameters?
    let encoding: QSParamEncode
    let headers: QSHTTPHeaders?
    
}

