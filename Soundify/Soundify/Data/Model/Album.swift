//
//  Album.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

//https://developer.spotify.com/documentation/web-api/reference/object-model/#album-object-full
// The external_urls key in JSON will be mapped to externalUrls by .convertFromSnakeCase
// So you have to set keyDecodingStrategy before decode
// let decoder = JSONDecoder()
// decoder.keyDecodingStrategy = .convertFromSnakeCase
struct Album: BaseModel {
    let albumType: String
    let artists: [Artis] = []
    let availableMarkets: [String]
    let externalIds: ExternalId?
    let externalUrls: ExternalUrl
    let genres: [String]?
    let href: String
    let id: String
    let images: [Image] = []
    let name: String
    let releaseDate: String?
    let releaseDatePrecision: String?
    let tracks: [Track]?
    let type: String
    let uri: String
    
}
