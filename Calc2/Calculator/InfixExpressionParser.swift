//
//  InfixExpressionParser.swift
//  Calc2
//
//  Created by user914614 on 4/7/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

class InfixExpressionParser {
    
    func addToken(_ token: Token, to expression: [Token]) -> [Token] {
        let previousToken = expression.last

        switch token.tokenType {
        case .openBracket:
            
            return addOpenBracket(token, to: expression, with: previousToken)
        case .closeBracket:
            
            return addCloseBracket(token, to: expression, with: previousToken)
        case .operand(let decimal, let literal):
            
            return addOperand((decimal: decimal, literal: literal), to: expression, with: previousToken)
        case .Operator(let operatorToken):
            
            return addOperatorToken(operatorToken, to: expression, with: previousToken)
        case .dot:
            
            return addDot(token, to: expression, with: previousToken)
        }
    }
    
    
    private func addMultiplyToken(before token: Token, expression: inout [Token]) {
        let multiplyToken = Token(operatorType: .multiply)
        expression.append(multiplyToken)
        expression.append(token)
    }
    
    private func swapLastToken(to token: Token, expression: inout [Token]) {
        expression.removeLast()
        expression.append(token)
    }
    
    private func makeNegativeOperand(operand: (decimal: Double, literal: String), expression: inout [Token]) {
        expression.removeLast()
        if let newOperandToken = Token(literal: OperatorType.subtract.description + operand.literal) {
            expression.append(newOperandToken)
        }
    }
    
    private func extendOperand(oldOperand: (decimal: Double, literal: String), with newOperand: (decimal: Double, literal: String), expression: inout [Token]) {
        expression.removeLast()
        if let newOperandToken = Token(literal: oldOperand.literal + newOperand.literal) {
            expression.append(newOperandToken)
        }
    }
    
    private func extendOperandWithDot(operand: (decimal: Double, literal: String), expression: inout [Token]) {
        if operand.literal.hasDot {
            return
        }
        
        if !expression.isEmpty {
            expression.removeLast()
        }
        
        if let newOperandToken = Token(literal: operand.literal + TokenType.dot.description) {
            expression.append(newOperandToken)
        }
    }
    
}

// MARK: - Brakets

extension InfixExpressionParser {
    private func addOpenBracket(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        var infixExpression = expression
    
        if let previousToken = previousToken {
            
            switch previousToken.tokenType {
            case .operand(_, _), .closeBracket, .dot:
                addMultiplyToken(before: token, expression: &infixExpression)
            case .Operator(_), .openBracket:
                infixExpression.append(token)
            }
            
        } else {
            infixExpression.append(token)
        }
        
        return infixExpression
    }
    
    private func addCloseBracket(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        var infixExpression = expression
        
        if let previousToken = previousToken {
            
            switch previousToken.tokenType {
            case .operand(_, _), .closeBracket, .dot, .openBracket:
                infixExpression.append(token)
            case .Operator(_):
                swapLastToken(to: token, expression: &infixExpression)
            }
            
        }
        
        return infixExpression
    }
}

// MARK: - Operand

extension InfixExpressionParser {
    private func addOperand(_ operand: (decimal: Double, literal: String), to expression: [Token], with previousToken: Token?) -> [Token] {
        var infixExpression = expression
        
        if let previousToken = previousToken {
            
            switch previousToken.tokenType {
            case .operand(let decimal, let literal):
                
                extendOperand(oldOperand: (decimal: decimal, literal: literal), with: (decimal: operand.decimal, literal: operand.literal), expression: &infixExpression)
            case .openBracket:
                
                infixExpression.append(Token(decimal: operand.decimal, literal: operand.literal))
            case .closeBracket, .dot:
                
                let newOperandToken = Token(decimal: operand.decimal, literal: operand.literal)
                addMultiplyToken(before: newOperandToken, expression: &infixExpression)
            case .Operator(_):
                
                if previousToken.isUnusedMinus {
                    makeNegativeOperand(operand: (decimal: operand.decimal, literal: operand.literal), expression: &infixExpression)
                } else {
                    infixExpression.append(Token(decimal: operand.decimal, literal: operand.literal))
                }
            }
            
        } else {
            infixExpression.append(Token(decimal: operand.decimal, literal: operand.literal))
        }
        
        return infixExpression
    }
}


// MARK: - Operator

extension InfixExpressionParser {
    private func addOperatorToken(_ operatorToken: OperatorToken, to expression: [Token], with previousToken: Token?) -> [Token] {
        var infixExpression = expression

        if let previousToken = previousToken {
            
            switch previousToken.tokenType {
            case .operand(_, _), .closeBracket:
                
                infixExpression.append(Token(operatorType: operatorToken.operatorType))
            case .openBracket, .dot:
                
                if operatorToken.operatorType == .subtract {
                    addUnusedMinusOperator(to: &infixExpression)
                }
            case .Operator(_):
                
                swapLastToken(to: Token(operatorType: operatorToken.operatorType), expression: &infixExpression)
            }
        } else {
            
            if operatorToken.operatorType == .subtract {
                addUnusedMinusOperator(to: &infixExpression)
            }
        }

        return infixExpression
    }
    
    private func addUnusedMinusOperator(to expression: inout [Token]) {
        var operatorToken = Token(operatorType: .subtract)
        operatorToken.isUnusedMinus = true
        expression.append(operatorToken)
    }
}

// MARK: - Dot

extension InfixExpressionParser {
    private func addDot(_ token: Token, to expression: [Token], with previousToken: Token?) -> [Token] {
        var infixExpression = expression
        
        if let previousToken = previousToken {
            
            switch previousToken.tokenType {
            case .operand(let decimal, let literal):
                
                extendOperandWithDot(operand: (decimal: decimal, literal: literal), expression: &infixExpression)
            case .openBracket, .Operator(_), .dot:
                
                extendOperandWithDot(operand: (decimal: 0, literal: "0"), expression: &infixExpression)
            case .closeBracket:
                
                if let operandToken = Token(literal: "0\(token.description)") {
                    addMultiplyToken(before: operandToken, expression: &infixExpression)
                }
            }
            
        } else {
            extendOperandWithDot(operand: (decimal: 0, literal: "0"), expression: &infixExpression)
        }
        
        return infixExpression
    }
}
