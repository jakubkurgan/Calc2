//
//  CalcViewModel.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

class CalcViewModel {
    
    // MARK: - Properties
    
    private(set) var keyboardDataList: [KeyCellData] = []
    private(set) var infixExpression = [Token]()
    weak var observer: CalcViewControllerObserver?
    
    var formattedExpression: String = "" {
        didSet {
            observer?.observer(didChange: formattedExpression)
        }
    }
    
    // MARK: - Init
    
    init() {
        setupKeyboardDataList()
    }
    
    // MARK: - Setup Keyboard Data
    
    private func setupKeyboardDataList() {
        keyboardDataList = [KeyCellData(keyType: .clear),
                            KeyCellData(keyType: .token(Token(tokenType: .openBracket))),
                            KeyCellData(keyType: .token(Token(tokenType: .closeBracket))),
                            KeyCellData(keyType: .token(Token(operatorType: .divide))),

                            KeyCellData(keyType: .token(Token(operand: 7))),
                            KeyCellData(keyType: .token(Token(operand: 8))),
                            KeyCellData(keyType: .token(Token(operand: 9))),
                            KeyCellData(keyType: .token(Token(operatorType: .multiply))),

                            KeyCellData(keyType: .token(Token(operand: 4))),
                            KeyCellData(keyType: .token(Token(operand: 5))),
                            KeyCellData(keyType: .token(Token(operand: 6))),
                            KeyCellData(keyType: .token(Token(operatorType: .subtract))),

                            KeyCellData(keyType: .token(Token(operand: 1))),
                            KeyCellData(keyType: .token(Token(operand: 2))),
                            KeyCellData(keyType: .token(Token(operand: 3))),
                            KeyCellData(keyType: .token(Token(operatorType: .add))),

                            KeyCellData(keyType: .delete),
                            KeyCellData(keyType: .token(Token(operand: 0))),
                            KeyCellData(keyType: .token(Token(tokenType: .dot))),
                            KeyCellData(keyType: .evaluate)]
    }
    
    // MARK: - Keyboard actions
    
    func keyTapped(with keyType: KeyType) {
        
        switch keyType {
        case .token(let token):
            addToken(token: token)
            formattedExpression = infixExpression.map { $0.description }.joined(separator: " ")
        case .evaluate:
            evaluateExpression()
        case.clear:
            cleareAll()
            formattedExpression = infixExpression.map { $0.description }.joined(separator: " ")
        case .delete:
            deleteLast()
            formattedExpression = infixExpression.map { $0.description }.joined(separator: " ")
        }
    }
    
    private func addToken(token: Token) {
        let previousToken = infixExpression.last
        
        switch token.tokenType {
        case .openBracket:
            addOpenBracket(token, with: previousToken)
        case .closeBracket:
            addCloseBracket(token, with: previousToken)
        case .operand(let operand):
            addOperand(operand, with: previousToken)
        case .Operator(let operatorToken):
            addOperatorToken(operatorToken, with: previousToken)
        case .dot:
            addDot(token)
        }
    }
    
    private func addOpenBracket(_ token: Token, with previousToken: Token?) {
        if let previousToken = previousToken {
            if previousToken.isOperand || previousToken.isCloseBracket {
                // example - token: '(', expression: '5' -> '5 * (', '( 5 * 5 )' -> '( 5 * 5) * ('
                
                let multiplyToken = Token(operatorType: .multiply)
                infixExpression.append(multiplyToken)
                infixExpression.append(token)
            } else if previousToken.isDot {
                if infixExpression.indices.contains(infixExpression.count - 2) {
                    let penultimateToken = infixExpression[infixExpression.count - 2]
                    if let penultimateOperand = penultimateToken.operand {
                        // example - token: '(', expression: '5 . ' -> '5.0 ('
                        
                        if let newToken = Token(operandDescription: "\(format: penultimateOperand)\(previousToken.description)\(format: 0)") {
                            infixExpression.removeLast() // remove previousToken dot
                            infixExpression.removeLast() // remove penultimateToken
                            infixExpression.append(newToken)
                            infixExpression.append(token)
                        } else {
                            // example - token: '(', expression: '3.4 . ' -> '3.4 * ('
                            
                            infixExpression.removeLast() // remove previousToken dot
                            let multiplyToken = Token(operatorType: .multiply)
                            infixExpression.append(multiplyToken)
                            infixExpression.append(token)
                        }
                    } else {
                        // example - token: '(', expression: '+ . ' -> '('
                        
                        infixExpression.removeLast()// remove previousToken dot
                        infixExpression.append(token)
                    }
                } else {
                    // example - token: '(', expression: ' . ' -> '('
                    
                    infixExpression.removeLast()// remove previousToken dot
                    infixExpression.append(token)
                }
                
            } else {
                // example - token: '(', expression: '5 +' -> '5 + (', '( 5 * 5 ) /' -> '( 5 * 5) / ('
                
                infixExpression.append(token)
            }
        } else {
            // example - token: '(', expression: '' -> '('
            
            infixExpression.append(token)
        }
    }
    
    private func addCloseBracket(_ token: Token, with previousToken: Token?) {
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
    }
    
    private func addOperand(_ operand: Double, with previousToken: Token?) {
        if let previousToken = previousToken {
            if previousToken.isOperand || (previousToken.isOperator && previousToken.isUnusedMinus) {
                // example - operand: 1, expression: '5' -> '51', '-' -> '-1', '5 - 5 -' -> ' 5 - 5 - 1'
                
                if let newToken = Token(oldOperandDescription: previousToken.description, newOperandDescription: "\(format: operand)") {
                    infixExpression.removeLast()
                    infixExpression.append(newToken)
                }
            } else if previousToken.isCloseBracket {
                // example - operand: 2, expression: '( 5 * 5)' -> '( 5 * 5) * 2'

                let multiplyToken = Token(operatorType: .multiply)
                infixExpression.append(multiplyToken)
                let newToken = Token(operand: operand)
                infixExpression.append(newToken)
            } else if previousToken.isDot {
                if infixExpression.indices.contains(infixExpression.count - 2) {
                    let penultimateToken = infixExpression[infixExpression.count - 2]
                    if let penultimateOperand = penultimateToken.operand {
                        // example - operand: 2, expression: '5 . ' -> '5.2'
                        
                        if let newToken = Token(operandDescription: "\(format: penultimateOperand)\(previousToken.description)\(format: operand)") {
                            infixExpression.removeLast() // remove previousToken dot
                            infixExpression.removeLast() // remove penultimateToken 2
                            infixExpression.append(newToken)
                        } else {
                            infixExpression.removeLast() // remove previousToken dot
                        }
                    } else {
                        // example - operand: 2, expression: '5 * . ' -> '5 * 0.2'
                        
                        if let newToken = Token(operandDescription: "\(format: 0)\(previousToken.description)\(format: operand)") {
                            infixExpression.removeLast() // remove previousToken
                            infixExpression.append(newToken)
                        }
                    }
                } else {
                    // example - operand: 2, expression: '. ' -> '0.2'
                    
                    if let newToken = Token(operandDescription: "\(format: 0)\(previousToken.description)\(format: operand)") {
                        infixExpression.removeLast() // remove previousToken
                        infixExpression.append(newToken)
                    }
                }
            } else {
                // example - operand: 1, expression: '9 / ' -> '9 / 1', '5 -' -> '5 - 1',  '5 *' -> ' 5 * 1'
                
                let newToken = Token(operand: operand)
                infixExpression.append(newToken)
            }
        } else {
            // example - operand: 1, expression: '' -> '1'
            
            let newToken = Token(operand: operand)
            infixExpression.append(newToken)
        }
    }
    
    private func addOperatorToken(_ operatorToken: OperatorToken, with previousToken: Token?) {
        
        if let previousToken = previousToken {
            if previousToken.isOperator {
                // example - operatorToken: '*', expression: '5 /' -> '5 *'
                
                let newToken = Token(operatorType: operatorToken.operatorType)
                infixExpression.removeLast()
                infixExpression.append(newToken)
            } else if previousToken.isOperand {
                // example - operatorToken: '*', expression: '5' -> '5 *'

                let newToken = Token(operatorType: operatorToken.operatorType)
                infixExpression.append(newToken)
            } else if previousToken.isOpenBracket, operatorToken.operatorType == .subtract {
                // example - operatorToken: '-', expression: '5 * (' -> '5 * ( -'
                
                var newToken = Token(operatorType: operatorToken.operatorType)
                newToken.isUnusedMinus = true
                infixExpression.append(newToken)
            } else if previousToken.isCloseBracket {
                // example - operatorToken: '-', expression: '5 * ( 2 * 2 )' -> '5 * ( 2 * 2 ) -'
                
                let newToken = Token(operatorType: operatorToken.operatorType)
                infixExpression.append(newToken)
            } else if previousToken.isDot {
                if infixExpression.indices.contains(infixExpression.count - 2) {
                    let penultimateToken = infixExpression[infixExpression.count - 2]
                    if let penultimateOperand = penultimateToken.operand {
                        // example - operatorToken: +, expression: '5 . ' -> '5.0 +'
                        
                        if let newToken = Token(operandDescription: "\(format: penultimateOperand)\(previousToken.description)\(format: 0)") {
                            infixExpression.removeLast() // remove previousToken dot
                            infixExpression.removeLast() // remove penultimateToken
                            infixExpression.append(newToken)
                            let newOperatorToken = Token(operatorType: operatorToken.operatorType)
                            infixExpression.append(newOperatorToken)
                        } else {
                            // example - operatorToken: +, expression: '5.5 . ' -> '5.5 +'
                            
                            infixExpression.removeLast() // remove previousToken dot
                            let newOperatorToken = Token(operatorType: operatorToken.operatorType)
                            infixExpression.append(newOperatorToken)
                        }
                    } else if penultimateToken.isOperator {
                        // example - operatorToken: + , expression: '5 * . ' -> '5 +'
                        infixExpression.removeLast() // remove dot
                        infixExpression.removeLast() // remove old operator
                        let newOperatorToken = Token(operatorType: operatorToken.operatorType)
                        infixExpression.append(newOperatorToken)
                    }
                } else {
                    // example - operatorToken: +, expression: ' . ' -> '+'
                    
                    infixExpression.removeLast()
                    let newOperatorToken = Token(operatorType: operatorToken.operatorType)
                    infixExpression.append(newOperatorToken)
                }
            }
        } else {
            // example - operatorToken: '*', expression: '' -> '', operatorToken: '-', expression: '' -> '-'
            
            if operatorToken.operatorType == .subtract {
                var newToken = Token(operatorType: operatorToken.operatorType)
                newToken.isUnusedMinus = true
                infixExpression.append(newToken)
            }
        }
    }
    
    private func evaluateExpression() {
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        print(result)
        if result.isInfinite || result.isNaN {
            formattedExpression += "\n = \("wrongEquationErrorMessage".localized)"
        } else {
            formattedExpression += "\n = \(result)"
            infixExpression = [Token(operand: result)]
        }
    }
    
    private func cleareAll() {
        infixExpression = []
    }
    
    private func deleteLast() {
        if let lastToken = infixExpression.popLast(), lastToken.isOperand, !lastToken.description.isEmpty {
            // example -  expression: '333' -> '33'
            
            var truncatedOperandDescription = lastToken.description
            truncatedOperandDescription.removeLast()
            if let truncatedOperandToken = Token(operandDescription: truncatedOperandDescription) {
                infixExpression.append(truncatedOperandToken)
            }
        }
    }
    
    private func addDot(_ token: Token) {
        infixExpression.append(token)
    }
}
