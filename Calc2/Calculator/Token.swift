//
//  Token.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

struct Token: CustomStringConvertible {
    let tokenType: TokenType
    
    init(tokenType: TokenType) {
        self.tokenType = tokenType
    }
    
    init(operand: Double) {
        tokenType = .operand(decimal: operand, literal: "\(format: operand)".formattedLiteralDescription)
    }
    
    init(decimal: Double, literal: String) {
        
        tokenType = .operand(decimal: decimal, literal: literal.formattedLiteralDescription)
    }
    
    init?(literal: String) {
        if let decimal = Double(literal.stringWithoutGroupingSeparator) {
            tokenType = .operand(decimal: decimal, literal: literal.formattedLiteralDescription)
        } else {
            return nil
        }
    }
    
    init(operatorType: OperatorType) {
        tokenType = .Operator(OperatorToken(operatorType: operatorType))
    }
    
    var isOpenBracket: Bool {
        switch tokenType {
        case .openBracket:
            return true
        default:
            return false
        }
    }
    
    var isCloseBracket: Bool {
        switch tokenType {
        case .closeBracket:
            return true
        default:
            return false
        }
    }
    
    func evaluate(previousOperand: Double?, nextOperand: Double?) -> Double {
        
        guard let previousOperand = previousOperand, let nextOperand = nextOperand, let operatorToken = operatorToken else {
            return Double.nan
        }
        
        switch operatorToken.operatorType {
            case .add:
                return previousOperand + nextOperand
            case .divide:
                return previousOperand / nextOperand
            case .multiply:
                return previousOperand * nextOperand
            case .subtract:
                return previousOperand - nextOperand
        }
    }
    
    var isUnusedMinus: Bool = false 
    
    var isOperator: Bool {
        switch tokenType {
        case .Operator(_):
            return true
        default:
            return false
        }
    }
    
    var isOperand: Bool {
        switch tokenType {
        case .operand(_):
            return true
        default:
            return false
        }
    }
    
    var isDot: Bool {
        switch tokenType {
        case .dot:
            return true
        default:
            return false
        }
    }

    var operand: (decimal: Double, literal: String)? {
        switch tokenType {
        case .operand(let decimal, let literal):
            return (decimal, literal)
        default:
            return nil
        }
    }
    
    var operatorToken: OperatorToken? {
        switch tokenType {
        case .Operator(let operatorToken):
            return operatorToken
        default:
            return nil
        }
    }
    
    var description: String {
        return tokenType.description
    }
}
