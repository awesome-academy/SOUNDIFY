//
//  HomeTableViewCell.swift
//  Soundify
//
//  Created by Viet Anh on 3/4/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func setUpCell(with album: Album) {
        backgroundColor = #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1)
        titleLable.text = album.name
        descriptionLabel.text = getDescription(of: album)
        if let url = getUrlImage(of: album) {
            albumImageView.load(url)
        }
    }
    
    private func getDescription(of album: Album) -> String {
        var description = [String]()
        let artists = album.artists
        artists.forEach { (artist) in
            description.append(artist.name)
        }
        return description.joined(separator: ", ")
    }
    
    private func getUrlImage(of album: Album) -> URL? {
        var stringURL = ""
        let images = album.images
        for image in images {
            if image.height == 64 {
                stringURL = image.url
            }
        }
        return URL(string: stringURL)
    }
}

