//
//  QSURLFormat.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/21.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation

public protocol QSURLFormat {
    /// return A URL or throws an QSError
    func asURL() throws -> URL
}

extension String: QSURLFormat {
    /// return: String -> URL
    /// throws: QSError.UnknownURL
    public func asURL() throws -> URL {
        guard let asURL = URL(string: self) else { throw QSError.UnknownURL(url: self) }
        return asURL
    }
}

extension URL: QSURLFormat {
    /// return self
    public func asURL() throws -> URL {  return self }
}

extension URLComponents: QSURLFormat {
    /// return: String -> URL
    /// throws: QSError.UnknownURL
    public func asURL() throws -> URL {
        guard let asURL = url else { throw QSError.UnknownURL(url: self) }
        return asURL
    }
}




