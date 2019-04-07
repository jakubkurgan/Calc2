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
        var infixExpression = expression
        if let previousToken = previousToken {
            if previousToken.isOperand || previousToken.isCloseBracket {
                // example - token: '(', expression: '5' -> '5 * (', '( 5 * 5 )' -> '( 5 * 5) * ('
                
                addMultiplyToken(before: token, expression: &infixExpression)
            } else if previousToken.isDot {
                if infixExpression.indices.contains(infixExpression.count - 2) {
                    let penultimateToken = infixExpression[infixExpression.count - 2]
                    if let penultimateOperand = penultimateToken.operand {
                        // example - token: '(', expression: '5 . ' -> '5.0 ('
                        
                        addDoubleValue(before: token, from: penultimateOperand, dotToken: previousToken, expression: &infixExpression)
                    } else {
                        // example - token: '(', expression: '+ . ' -> '('
                        
                        swapLastToken(to: token, expression: &infixExpression)
                    }
                } else {
                    // example - token: '(', expression: ' . ' -> '('
                    
                    swapLastToken(to: token, expression: &infixExpression)
                }
            } else {
                // example - token: '(', expression: '5 +' -> '5 + (', '( 5 * 5 ) /' -> '( 5 * 5) / ('
                
                infixExpression.append(token)
            }
        } else {
            // example - token: '(', expression: '' -> '('
            
            infixExpression.append(token)
        }
        return infixExpression
    }
    
    private func addMultiplyToken(before token: Token, expression: inout [Token]) {
        let multiplyToken = Token(operatorType: .multiply)
        expression.append(multiplyToken)
        expression.append(token)
    }
    
    private func addDoubleValue(before token: Token, from penultimateOperand: Double, dotToken: Token, expression: inout [Token]) {
        if let newToken = Token(operandDescription: "\(format: penultimateOperand)\(dotToken.description)\(format: 0)") {
            expression.removeLast() // remove previousToken dot
            expression.removeLast() // remove penultimateToken
            expression.append(newToken)
            expression.append(token)
        } else {
            // example - token: '(', expression: '3.4 . ' -> '3.4 * ('
            
            expression.removeLast() // remove previousToken dot
            let multiplyToken = Token(operatorType: .multiply)
            expression.append(multiplyToken)
            expression.append(token)
        }
    }
    
    private func swapLastToken(to token: Token, expression: inout [Token]) {
        expression.removeLast()
        expression.append(token)
    }
    
    
    private func addCloseBracket(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        var infixExpression = expression
        if let previousToken = previousToken, (previousToken.isOperand || previousToken.isOpenBracket) {
            // example - token: ')', expression: '( 3 + 4 ' -> '( 3 + 4 )'
            
            infixExpression.append(token)
        } else if let previousToken = previousToken, previousToken.isDot {
            if infixExpression.indices.contains(infixExpression.count - 2) {
                let penultimateToken = infixExpression[infixExpression.count - 2]
                if let penultimateOperand = penultimateToken.operand {
                    // example - token: ')', expression: '5 . ' -> '5.0 )'
                    
                    if let newToken = Token(operandDescription: "\(format: penultimateOperand)\(previousToken.description)\(format: 0)") {
                        infixExpression.removeLast() // remove previousToken dot
                        infixExpression.removeLast() // remove penultimateToken
                        infixExpression.append(newToken)
                        infixExpression.append(token)
                    } else {
                        // example - token: ')', expression: '3.4 . ' -> '3.4 )'
                        
                        infixExpression.removeLast() // remove previousToken dot
                        infixExpression.append(token)
                    }
                } else {
                    // example - token: ')', expression: '+ . ' -> ')'
                    
                    infixExpression.removeLast()// remove previousToken dot
                    infixExpression.append(token)
                }
            } else {
                // example - token: ')', expression: ' . ' -> ''
                
                infixExpression.removeLast()// remove previousToken dot
                infixExpression.append(token)
            }
            
        } else if !infixExpression.isEmpty {
            // example - token: ')', expression: '( 3 + 4 *' -> '( 3 + 4 )'
            
            infixExpression.removeLast()
            infixExpression.append(token)
        }
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
