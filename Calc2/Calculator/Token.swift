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
        tokenType = .operand(operand)
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
    
    var operand: Double? {
        switch tokenType {
        case .operand(let result):
            return result
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
