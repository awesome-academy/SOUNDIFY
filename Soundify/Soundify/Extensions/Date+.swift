//
//  Date+.swift
//  Soundify
//
//  Created by Viet Anh on 3/17/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

extension Date {
    
    var requestFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var onlyYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter
    }
    
    var fullyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, y"
        return formatter
    }
    
}

