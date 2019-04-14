//
//  InfixExpressionParserTests.swift
//  Calc2Tests
//
//  Created by Jakub Kurgan on 14/04/2019.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import XCTest
@testable import Calc2

class InfixExpressionParserTests: XCTestCase {
    
    func testExtendOperand() {
        let infixExpression: [Token] = [Token(operand: 20),
                                        Token(operatorType: .add),
                                        Token(operand: 2)]
        
        let infixExpressionParser = InfixExpressionParser()
        
        
        let resultExpression = infixExpressionParser.addToken(Token(operand: 2), to: infixExpression)
        
        XCTAssertEqual(resultExpression.last?.operand?.decimal, 22)
    }
    
    func testExtendOperandWithDot() {
        let infixExpression: [Token] = [Token(operand: 20),
                                        Token(operatorType: .add),
                                        Token(operand: 2)]
        
        let infixExpressionParser = InfixExpressionParser()
        
        
        let resultExpression = infixExpressionParser.addToken(Token(tokenType: .dot), to: infixExpression)
        
        XCTAssertEqual(resultExpression.last?.operand?.literal, "2.")
    }
    
}
