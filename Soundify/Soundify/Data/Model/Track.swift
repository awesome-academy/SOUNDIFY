//
//  Track.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

//https://developer.spotify.com/documentation/web-api/reference/object-model/#track-object-full
// The external_urls key in JSON will be mapped to externalUrls by .convertFromSnakeCase
// So you have to set keyDecodingStrategy before decode
// let decoder = JSONDecoder()
// decoder.keyDecodingStrategy = .convertFromSnakeCase
struct Track: BaseModel {
    let album: Album?
    let artists: [Artis] = []
    let availableMarkets: [String] = []
    let discNumber: Int
    let durationMs: Int
    let externalIds: ExternalId?
    let externalUrls: ExternalUrl
    let href: String
    let id: String
    let name: String
    let previewUrl: String
    let trackNumber: Int
    let type: String
    let uri: String
}
