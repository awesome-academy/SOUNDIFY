//
//  HeaderDetailAlbumTableViewCell.swift
//  Soundify
//
//  Created by Viet Anh on 3/14/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import Reusable

class HeaderDetailAlbumTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistsLabel: UILabel!
    @IBOutlet private weak var typeAlbumLabel: UILabel!
    
    func setUpView(with album: Album, artists: [Artis]) {
        backgroundColor = #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1)
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        typeAlbumLabel.text = album.albumType.capitalized + " • " + formatter.string(from: album.releaseDate)
        nameLabel.text = album.name
        
        if artists.count < 2 {
            artistsLabel.text = artists.first?.name
        } else {
            artistsLabel.text = artists[1...].reduce(artists.first?.name ?? ""){ $0 + " • " + $1.name }
        }
    }
    
}
