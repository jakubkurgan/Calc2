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
    
    var hasDot: Bool {
        return self.contains(TokenType.dot.description)
    }
    
    var formattedLiteralDescription: String  {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let inputWithoutGroupingSeparator = self.stringWithoutGroupingSeparator
        
        guard let decimalNumber = Double(inputWithoutGroupingSeparator) else {
            return ""
        }
        
        let components = inputWithoutGroupingSeparator.components(separatedBy: TokenType.dot.description)
        
        if self.hasDot, components.count == 2,
            let integerLiteral = components.first,
            let fractionalLiteral = components.last,
            let integerValue = Int(integerLiteral),
            let formattedIntegerLiteral = formatter.string(from: NSNumber(value: integerValue)) {
            
            let formattedLiteral = "\(formattedIntegerLiteral)\(TokenType.dot.description)\(fractionalLiteral)"
            
            return formattedLiteral
        } else {
            return formatter.string(from: NSNumber(value: decimalNumber)) ?? ""
        }
    }
    
    var stringWithoutGroupingSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return self.filter { String($0) != formatter.groupingSeparator }
    }
    
}

extension String.StringInterpolation {
    mutating func appendInterpolation(format value: Double) {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            appendLiteral("\(String(format: "%.0f", value))")
        } else {
            appendLiteral("\(String(format: "%.2f", value))")
        }
    }
}
