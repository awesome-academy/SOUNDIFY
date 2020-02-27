//
//  SpotifyService.swift
//  Soundify
//
//  Created by Viet Anh on 2/25/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

struct SpotifyService {
    static let shared = SpotifyService()
    
    private func printRequest(_ request: BaseRequest) {
        print("\n------------REQUEST INPUT")
        print("type: %@", request.requestType.rawValue)
        print("link: %@", request.url)
        print("header: %@", request.header ?? "No Header")
        print("parameter: %@", request.parameter ?? "No Parameter")
        print("------------ END REQUEST INPUT\n")
    }
    
    func requestPost<T: Codable> (request: BaseRequest, completion: @escaping (_ value: T?,_ error: Error?) -> Void) {
        printRequest(request)
        
        guard let url = URL(string: request.url) else { return }
        guard let header = request.header else { return }
        guard let parameter = request.parameter  else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.requestType.rawValue
        urlRequest.httpBody = parameter.percentEncoded()
        
        for (key,value) in header {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(nil,error)
            } else {
                guard let data = data else {
                    completion(nil,nil)
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let result = try? decoder.decode(T.self, from: data) {
                    completion(result,nil)
                }
            }
        }.resume()
    }
}
