//
//  HomeTableViewCell.swift
//  Soundify
//
//  Created by Viet Anh on 3/4/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    //MARK: - Variable
    var album: Album?
    
    private lazy var descriptionAlbum: String = {
        var description = ""
        if let artists = album?.artists {
            for (index,artist) in artists.enumerated() {
                if index == artists.count - 1 {
                    description += "\(artist.name)"
                } else {
                    description += "\(artist.name), "
                }
            }
        }
        return description
    }()
    
    private lazy var urlImage: URL? = {
        var stringURL = ""
        if let images = album?.images {
            for image in images {
                if image.height == 64 {
                    stringURL = image.url
                }
            }
        }
        return URL(string: stringURL)
    }()
    
    
    func setUpCell() {
        titleLable.text = album?.name
        descriptionLabel.text = descriptionAlbum
        if let url = urlImage {
            albumImageView.load(url: url)
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

