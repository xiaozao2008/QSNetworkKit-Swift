//
//  QSNetworkError.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/21.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation


enum QSError: Error {
    
    case UnknownURL(url: URLFormatProtocol)  /// 未知URL
}
