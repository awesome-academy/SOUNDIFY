//
//  TextTableViewCell.swift
//  Soundify
//
//  Created by Viet Anh on 3/13/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import Reusable

class TextTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var detailLabel: UILabel!
    
    func setUpCell(with text: String){
        backgroundColor = #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1)
        detailLabel.text = text
    }
    
}
