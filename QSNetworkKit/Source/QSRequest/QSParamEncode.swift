//
//  QSParamEncode.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/22.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol QSParamEncode {
    func encode(_ urlRequest: QSRequestFormat, with parameters: Parameters?) throws -> URLRequest
}

struct QSJSONEncoding: QSParamEncode {
    
    public static var `default`: QSJSONEncoding { return QSJSONEncoding() }
    public static var prettyPrinted: QSJSONEncoding { return QSJSONEncoding(options: .prettyPrinted) }
    
    public let options: JSONSerialization.WritingOptions
    
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: QSRequestFormat, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        guard let parameters = parameters else { return urlRequest }
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
            let headerKey = QSHTTPHeader.QSHTTPHeaderAcceptName.contentType.rawValue
            if urlRequest.value(forHTTPHeaderField: headerKey) == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: headerKey)
            }
            urlRequest.httpBody = data
        } catch {
            throw QSError.EncodingFailed(error: error)
        }
        return urlRequest
    }
    
    public func encode(_ urlRequest: QSRequestFormat, with jsonObject: Any? = nil) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        guard let jsonObject = jsonObject else { return urlRequest }
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            let headerKey = QSHTTPHeader.QSHTTPHeaderAcceptName.contentType.rawValue
            if urlRequest.value(forHTTPHeaderField: headerKey) == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: headerKey)
            }
            urlRequest.httpBody = data
        } catch {
            throw QSError.EncodingFailed(error: error)
        }
        return urlRequest
    }
}

struct QSURLEncoding: QSParamEncode {
    
    /// TODO header/get/delete/queryString使用拼接URL的方式
    /// 其他保持不便
    func encode(_ urlRequest: QSRequestFormat, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        
        return urlRequest
    }
    
}
