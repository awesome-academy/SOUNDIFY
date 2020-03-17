//
//  Formatter+.swift
//  Soundify
//
//  Created by Viet Anh on 3/16/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

extension Formatter {
    
    static let separatorNumberWithComma: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
