//
//  QSRequestFormat.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/22.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation


public protocol QSRequestFormat {
    /// return A URLRequest or throws an QSError
    func asURLRequest() throws -> URLRequest
}

extension QSRequestFormat {
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: QSRequestFormat {
    public func asURLRequest() throws -> URLRequest { return self }
}

extension URLRequest {
    init(url: QSURLFormat, method: QSHTTPMethod, headers: QSHTTPHeaders? = nil) throws {
        let url = try url.asURL()
        self.init(url: url)
        httpMethod = method.rawValue
        allHTTPHeaderFields = headers?.dictionary
    }
}
