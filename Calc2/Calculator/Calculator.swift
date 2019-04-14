//
//  Calculator.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

class Calculator {
    
    func evaluateExpression(from infixExpression: [Token], completion: @escaping (Result<Token, Error>) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            if let postfix = self?.generatePostfixNotation(from: infixExpression),
                let result = self?.evaluatePostfixExpression(postfix), (!result.isInfinite && !result.isNaN) {
                
                DispatchQueue.main.async {
                    completion(.success(Token(operand: result)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CalculatorError.wrongEquation))
                }
            }
        }
    }

    private func generatePostfixNotation(from infixExpression: [Token]) -> [Token] {
        
        var tokenStack = Stack<Token>()
        var postfixNotation = [Token]()
        
        for token in infixExpression {
            switch token.tokenType {
            case .operand(_):
                postfixNotation.append(token)
                
            case .openBracket:
                tokenStack.push(token)
                
            case .closeBracket:
                while tokenStack.count > 0, let tempToken = tokenStack.pop(), !tempToken.isOpenBracket {
                    postfixNotation.append(tempToken)
                }
                
            case .Operator(let operatorToken):
                for tempToken in tokenStack.makeIterator() {
                    if !tempToken.isOperator {
                        break
                    }
                    
                    if let tempOperatorToken = tempToken.operatorToken {
                        if operatorToken.precedence <= tempOperatorToken.precedence {
                            postfixNotation.append(tokenStack.pop()!)
                        } else {
                            break
                        }
                    }
                }
                tokenStack.push(token)
            case .dot:
                break
            }
        }
        
        while tokenStack.count > 0 {
            postfixNotation.append(tokenStack.pop()!)
        }
        
        return postfixNotation
    }
    
    private func evaluatePostfixExpression(_ expression: [Token]) -> Double {
        
        if expression.isEmpty {
            return 0
        }
        
        var operandStack = Stack<Double>()
        
        for token in expression {
            if token.isOperator {
                let nextOperand = operandStack.pop()
                let previousOperand = operandStack.pop()
                
                let newOperand = token.evaluate(previousOperand: previousOperand, nextOperand: nextOperand)
                operandStack.push(newOperand)
            } else if let decimal = token.operand?.decimal, !decimal.isNaN {
                operandStack.push(decimal)
            }
        }

        return operandStack.pop() ?? Double.nan
    }
}
