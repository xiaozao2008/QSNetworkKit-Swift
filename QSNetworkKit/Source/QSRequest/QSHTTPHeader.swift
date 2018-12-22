//
//  QSHeader.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/21.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation

extension QSHTTPHeaders {
    
    public static let `default`: QSHTTPHeaders = [.defaultAcceptEncoding,
                                                  .defaultAcceptLanguage,
                                                  .defaultUserAgent]
}

public struct QSHTTPHeaders {
    
    private var headers = [QSHTTPHeader]()
    
    private init() { }
    
    /// Init QSHTTPHeaders
    ///
    /// - Parameter header: [QSHTTPHeader]]
    public init(_ header: [QSHTTPHeader]) {
        self.init()
        header.forEach { update($0) }
    }
    
    /// Init QSHTTPHeaders
    ///
    /// - Parameter dictionary: [String: String]]
    public init(_ dictionary: [String: String]) {
        self.init()
        dictionary.forEach { update(QSHTTPHeader(name: $0.key, value: $0.value)) }
    }
    
    /// Add QSHTTPHeader to QSHttpHeaders
    ///
    /// - Parameters:
    ///   - name: The `QSHTTPHeader` name
    ///   - value: The `QSHTTPHeader` value
    public mutating func add(name: String, value: String) {
        update(QSHTTPHeader(name: name, value: value))
    }
    
    /// Add QSHTTPHeader to QSHttpHeaders
    ///
    /// - Parameter header: The `QSHTTPHeader` to update or append
    public mutating func add(_ header: QSHTTPHeader) {
        update(header)
    }
    
    /// Add/update QSHTTPHeader to QSHttpHeaders
    ///
    /// - Parameter header: The `QSHTTPHeader` to update or append
    public mutating func update(_ header: QSHTTPHeader) {
        guard let index = headers.index(of: header.name) else {
            headers.append(header)
            return
        }
        headers.replaceSubrange(index...index, with: [header])
    }
    
    /// Add/update QSHTTPHeader to QSHttpHeaders
    ///
    /// - Parameters:
    /// - name: The `QSHTTPHeader` name
    /// - value: The `QSHTTPHeader` value
    public mutating func update(name: String, value: String) {
        update(QSHTTPHeader(name: name, value: value))
    }
    
    /// remove QSHttpHeader from QSHTTPHeaders
    ///
    /// - Parameter name: The name of the `QSHTTPHeader` to remove
    public mutating func remove(name: String) {
        guard let index = headers.index(of: name) else { return }
        headers.remove(at: index)
    }
    
    /// Find a header's value by name
    ///
    /// - Parameter name: The name of the header to search
    /// - Returns: The value of header, if it exists
    public func value(for name: String) -> String? {
        guard let index = headers.index(of: name) else { return nil}
        return headers[index].value
    }
    
    /// Sort the current instance by userDefine method
    public mutating func sort(by order:(QSHTTPHeader, QSHTTPHeader) -> Bool)  {
        headers.sort { order($0, $1) }
    }
    
    /// Sort the current instance by userDefine method && return An new QSHTTPHeaders
    public mutating func sort(by order:(QSHTTPHeader, QSHTTPHeader) -> Bool) -> QSHTTPHeaders {
        return QSHTTPHeaders.init(headers.sorted { order($0, $1) })
    }
    
    /// Case-insensitively to set/get QSHTTPHeaders
    ///
    /// - Parameter name: The name of the header
    public subscript(_ name: String) -> String? {
        set {
            if let value = newValue {
                update(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
        get {
            return value(for: name)
        }
    }
    
    /// The dictionary representation of all headers
    public var dictionary: [String: String] {
        let namesAndValue = headers.map {($0.name, $0.value) }
        return Dictionary(namesAndValue, uniquingKeysWith: { (_, last) in last })
    }
}

/// 支持以数组的方式初始化, 也支持h数组的遍历等方法
/// For Example
/// let header1 = QSHTTPHeader(name: "1", value: "2")
/// let header2 = QSHTTPHeader(name: "2", value: "2")
/// let newHeaders = [header1, header2]
extension QSHTTPHeaders: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = QSHTTPHeader
    public init(arrayLiteral elements: QSHTTPHeaders.ArrayLiteralElement...) {
        self.init(elements)
    }
}

/// 支持一下数组类型的迭代器for in
extension QSHTTPHeaders: Sequence {
    
    public func makeIterator() -> IndexingIterator<[QSHTTPHeader]> {
        return headers.makeIterator()
    }
}

/// 支持一下数组下标等功能
extension QSHTTPHeaders: Collection {
    
    public func index(after i: Int) -> Int {
        return headers.index(after: i)
    }
    
    public subscript(position: Int) -> QSHTTPHeader {
        return headers[position]
    }
    
    public var startIndex: Int {
        return headers.startIndex
    }
    
    public var endIndex: Int {
        return headers.endIndex
    }
}

/// 支持一下debug信息
extension QSHTTPHeaders: CustomStringConvertible {
    public var description: String {
        return headers.map { $0.description }.joined(separator: "\n")
    }
}

/// 支持以字典的方式初始化
/// let newHeaders = ["name1": "value1", "name2": "value2"]
extension QSHTTPHeaders: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = String
    
    public init(dictionaryLiteral elements: (QSHTTPHeaders.Key, QSHTTPHeaders.Value)...) {
        self.init()
        elements.forEach { update(name: $0.0, value: $0.1) }
    }
}


/// Base HTTPHeader
public struct QSHTTPHeader: Hashable {
    
    /// Name of Header
    let name: String
    
    /// Value of Header
    let value: String
    
    /// Create an instance with Name && Value
    ///
    /// - Parameters:
    ///   - name: The name of the header
    ///   - value: Ther value of the header
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension QSHTTPHeader: CustomStringConvertible {
    public var description: String {
        return name + ": " + value
    }
}

/// 此处配置一些常用Header的枚举, 直接返回QSHTTPHeader, 已经填充好默认参数
extension QSHTTPHeader {
    
    /// header中默认的Accept-encoding参数
    /// Default Accept-encoding
    /// See the [Accept-Encoding HTTP header documentation](https://tools.ietf.org/html/rfc7230#section-4.2.3) .
    public static let defaultAcceptEncoding: QSHTTPHeader = {
        let encodings: [String]
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            encodings = ["br", "gzip", "deflate"]
        } else {
            encodings = ["gzip", "deflate"]
        }
        return .createHeader(.acceptEncoding, value: encodings.qualityEncoded)
    }()
    
    /// header中默认的Accept-Language参数, 设备所属地区, 最多6个字符长度
    /// Default Accept-Language
    /// See the [Accept-Language HTTP header documentation](https://tools.ietf.org/html/rfc7231#section-5.3.5).
    public static let defaultAcceptLanguage: QSHTTPHeader = {
       return .createHeader(.acceptLanguage, value: Locale.preferredLanguages.prefix(6).qualityEncoded)
    }()
    
    /// 构建一个user-agent的header
    public static let defaultUserAgent: QSHTTPHeader = {
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                /// Current Target Name For Example SQNetWorkKit
                /// 工程名称, target名称
                let excutable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundleID = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion =  info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                let qsVersion: String = {
                    guard let version = Bundle(for: QSNetworkManager.self).infoDictionary?["CFBundleShortVersionString"] as? String else {
                        return "Unknown"
                    }
                    return "QSNetwork/\(version)"
                }()
                return "\(excutable)/\(appVersion) (\(bundleID); build:\(appBuild); \(defaultOSName()) \(qsVersion))"
            }
            return "QSNetworkKit"
        }()
        return .createHeader(.userAgent, value: "")
    }()
    
    
    static func defaultOSName() -> String {
        #if os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(macOS)
        return "macOS"
        #elseif os(Linux)
        return "Linux"
        #else
        return "Unknown"
        #endif
    }
    
}




/// 一些基础的, 比较通用的Header参数, 用来创建QSHTTPHeader
/// 如果没有包含可以使用 QSHTTPHeader.createHeader(QSHTTPHeader.QSHTTPHeaderAcceptName.custrom(xxx), value: xxx)
/// Base Header Params
extension QSHTTPHeader {
    
    /// Returns an QSHTTPHeaderAcceptParams
    ///
    /// - acceptCharset: An Accept-Charset header name
    /// - acceptLanguage: An Accept-Language header name
    /// - acceptEncoding: An Accept-Encoding header name
    /// - contentDisposition: An Content-Disposition header name
    /// - contentType: An Content-Type header name
    /// - userAgent: An User-Agent header name
    /// - authorization: An Authorization header name
    /// - custrom: An user-defined header name
   public enum QSHTTPHeaderAcceptName: RawRepresentable {
        
        public typealias RawValue = String
        public init?(rawValue: String) { self = .custrom(rawValue) }
        
        case acceptCharset
        case acceptLanguage
        case acceptEncoding
        case contentDisposition
        case contentType
        case userAgent
        case authorization
        case custrom(String)
        
       public var rawValue: String {
            switch self {
            case .custrom(let user_Defined_Name):
                return user_Defined_Name
            case .acceptCharset:
                return "Accept-Charset"
            case .acceptLanguage:
                return "Accept-Language"
            case .acceptEncoding:
                return "Accept-Encoding"
            case .contentDisposition:
                return "Content-Disposition"
            case .contentType:
                return "Content-Type"
            case .userAgent:
                return "User-Agent"
            case .authorization:
                return "Authorization"
            }
        }
    }
    
    /// Return a QSHTTPHeader
    ///
    /// - Parameters:
    ///   - key: QSHTTPHeaderAcceptParams.rawValue
    ///   - value: QSHTTPHeaderAcceptParams.rawValue's Value
    /// - Returns: QSHttpHeader
    public static func createHeader(_ key: QSHTTPHeaderAcceptName, value: String) -> QSHTTPHeader {
        return QSHTTPHeader(name: key.rawValue, value: value)
    }
    
    /// Return a QSHTTPHeader
    ///
    /// - Parameter bearerToken: Bearer Token
    /// - Returns: QSHTTPHeader
    public static func authorizationHeader(bearerToken: String) -> QSHTTPHeader {
        return QSHTTPHeader.createHeader(.authorization,
                                         value: "Bearer \(bearerToken)")
    }
    
    /// Return a QSHTTPHeader
    ///
    /// - Parameters:
    ///   - username: The username of the header
    ///   - password: The password of the header
    /// - Returns: The Header
    public static func authorizationHeader(username: String, password: String) -> QSHTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()
        return QSHTTPHeader.createHeader(.authorization,
                                         value: "Basic \(credential)")
    }
}


extension Collection where Element == String {
    
    var qualityEncoded: String {
        return enumerated().map({ (index, encoding) -> String in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }).joined(separator: ", ")
    }
}

extension Array where Element == QSHTTPHeader {
    
    func index(of name: String) -> Int? {
        let lowercasedName = name.lowercased()
        return firstIndex { $0.name.lowercased() == lowercasedName }
    }
}
