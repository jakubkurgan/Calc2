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
                            KeyCellData(keyType: .dot),
                            KeyCellData(keyType: .evaluate)]
    }
    
    // MARK: - Keyboard actions
    
    func keyTapped(with keyType: KeyType) {
        
        switch keyType {
        case .token(let token):
            addToken(token: token)
        case .evaluate:
            evaluateExpression()
        case.clear:
            cleareAll()
        case .delete:
            deleteLast()
        case .dot:
            addDot()
        }
        print(infixExpression)
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
        }
    }
    
    private func addOpenBracket(_ token: Token, with previousToken: Token?) {
        if let previousToken = previousToken {
            if previousToken.isOperand || previousToken.isCloseBracket {
                // example - token: '(', expression: '5' -> '5 * (', '( 5 * 5 )' -> '( 5 * 5) * ('
                
                let multiplyToken = Token(operatorType: .multiply)
                infixExpression.append(multiplyToken)
                infixExpression.append(token)
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
        if let previousToken = previousToken, !previousToken.isOperator {
            // example - token: ')', expression: '( 3 + 4 ' -> '( 3 + 4 )'
            
            infixExpression.append(token)
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
        let postfix = Calculator.shared.generatePostfixNotation(from: infixExpression)
        let result = Calculator.shared.evaluatePostfixExpression(postfix)
        print(postfix)
        print(result)
        infixExpression = []
    }
    
    private func cleareAll() {
        infixExpression = []
    }
    
    private func deleteLast() {
        if let lastToken = infixExpression.popLast(), lastToken.isOperand, !lastToken.description.isEmpty {
            // example -  expression: '333' -> '33'
            
            var truncatedOperandDescription = lastToken.description
            truncatedOperandDescription.removeLast()
            if let truncatedOperandToken = Token(truncatedOperandDescription: truncatedOperandDescription) {
                infixExpression.append(truncatedOperandToken)
            }
        }
    }
    
    private func addDot() {
        
    }
}
