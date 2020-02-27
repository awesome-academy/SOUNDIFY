//
//  URLRequest+.swift
//  Soundify
//
//  Created by Viet Anh on 2/27/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

//Get code after login to request access_token and refresh_token
//https://developer.spotify.com/documentation/general/guides/authorization-guide/
extension URLRequest {
    func queryString (after key: String) -> String? {
        let requestURLString = (self.url?.absoluteString)! as String
        if let range = requestURLString.range(of: key) {
            let code = requestURLString[range.upperBound...]
            return String(code)
        }
        return nil
    }
}
