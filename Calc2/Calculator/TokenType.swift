//
//  TokenType.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

enum TokenType: CustomStringConvertible {
    case openBracket
    case closeBracket
    case Operator(OperatorToken)
    case operand(decimal: Double, literal: String)
    case dot
    
    var description: String {
        switch self {
        case .openBracket:
            return "("
        case .closeBracket:
            return ")"
        case .Operator(let operatorToken):
            return operatorToken.description
        case .operand(_, let literal):
            return literal.formattedLiteralDescription
        case .dot:
            return "."
        }
    }
}
