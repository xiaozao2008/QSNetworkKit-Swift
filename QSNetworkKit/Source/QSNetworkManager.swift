//
//  QSNetworkManager.swift
//  QSNetworkKit
//
//  Created by xiaozao on 2018/12/20.
//  Copyright © 2018 Tony. All rights reserved.
//

import Foundation



class QSNetwork {
    
    
    public static func request(_ url: QSURLFormat, method: QSHTTPMethod = .get, headers: QSHTTPHeaders? = nil,  params: [String: Any]? = nil) -> Data? {
        
        if let request = try? URLRequest.init(url: url, method: method, headers: headers) {
//            request.httpBody =
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            }.resume()
        }
        
        return nil
    }
    
}
