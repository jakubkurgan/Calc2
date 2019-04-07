//
//  InfixExpressionParser.swift
//  Calc2
//
//  Created by user914614 on 4/7/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

class InfixExpressionParser {
    
    static let shared = InfixExpressionParser()
    
    private init() {
        
    }
    
    func addToken(_ token: Token, to expression: [Token]) -> [Token] {
        let previousToken = expression.last
        
        switch token.tokenType {
        case .openBracket:
            return addOpenBracket(token, to: expression , with: previousToken)
        case .closeBracket:
            return addCloseBracket(token, to: expression, with: previousToken)
        case .operand(let operand):
            return addOperand(operand, to: expression, with: previousToken)
        case .Operator(let operatorToken):
            return addOperatorToken(operatorToken, to: expression, with: previousToken)
        case .dot:
            return addDot(token, to: expression, with: previousToken)
        }
    }
}

// MARK: - Brakets

extension InfixExpressionParser {
    private func addOpenBracket(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        
        return []
    }
    
    private func addCloseBracket(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        
        return []
    }
}

// MARK: - Operand

extension InfixExpressionParser {
    private func addOperand(_ operand: Double, to expression: [Token], with previousToken: Token?) -> [Token] {
        
        return []
    }
}

// MARK: - Operator

extension InfixExpressionParser {
    private func addOperatorToken(_ operatorToken: OperatorToken, to expression: [Token], with previousToken: Token?) -> [Token] {
        
        return []
    }
}

// MARK: - Operator

extension InfixExpressionParser {
    private func addDot(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        
        return []
    }
}
