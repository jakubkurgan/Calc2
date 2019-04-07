//
//  String+Extension.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(format value: Double) {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            appendLiteral("\(Int(value))")
        } else {
            appendLiteral("\(value)")
        }
    }
}
