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
            infixExpression.append(token)
            print(infixExpression)
        case .evaluate:
            let postfix = Calculator.shared.generatePostfixNotation(from: infixExpression)
            let result = Calculator.shared.evaluatePostfixExpression(postfix)
            print(postfix)
            print(result)
            infixExpression.removeAll()
        default:
            break
        }
    }
}
