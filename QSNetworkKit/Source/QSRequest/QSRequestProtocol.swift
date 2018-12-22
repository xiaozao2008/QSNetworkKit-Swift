//
//  QSURLRequestProtocol.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/22.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation


public protocol URLRequestFormatProtocol {
    /// return A URLRequest or throws an QSError
    func asURLRequest() throws -> URLRequest
}

extension URLRequestFormatProtocol {
    
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}
