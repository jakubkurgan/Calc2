//
//  Calc2Tests.swift
//  Calc2Tests
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import XCTest
@testable import Calc2

class Calc2Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleAddition() {
        let infixExpression: [Token] = [Token(operand: 20),
                                        Token(operatorType: .add),
                                        Token(operand: 2)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssertEqual(result, 22, "\(infixExpression.description)")
    }
    
    func testEquationOrder() {
        let infixExpression: [Token] = [Token(operand: 2),
                                        Token(operatorType: .add),
                                        Token(operand: 2),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssertEqual(result, 6, "\(infixExpression.description)")
    }
    
    func testtEquationOrderWithParanteses() {
        let infixExpression: [Token] = [Token(tokenType: .openBracket),
                                        Token(operand: 2),
                                        Token(operatorType: .add),
                                        Token(operand: 2),
                                        Token(tokenType: .closeBracket),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssertEqual(result, 8, "\(infixExpression.description)")
    }
    
    func testtDecimalAddition() {
        let infixExpression: [Token] = [Token(operand: 2.2),
                                        Token(operatorType: .add),
                                        Token(operand: 9.7),
                                        Token(operatorType: .add),
                                        Token(operand: 3.2)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssertEqual(result, 15.1, accuracy: 0.000000001, "\(infixExpression)")
    }
    
    func testDecimalMultiplying() {
        let infixExpression: [Token] = [Token(operand: 0.5),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2.2),
                                        Token(operatorType: .multiply),
                                        Token(operand: 10)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssertEqual(result, 11, accuracy: 0.000000001, "\(infixExpression)")
    }
    
    func testDivideByZeroReturnInf() {
        let infixExpression: [Token] = [Token(operand: 0.5),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2.2),
                                        Token(operatorType: .divide),
                                        Token(operand: 0)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssert(result.isInfinite, "division by zero return infinite")
    }
    
    func testWrongEquationReturnNan() {
        let infixExpression: [Token] = [Token(operand: 0.5),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2.2),
                                        Token(operatorType: .divide)]
        
        let result = Calculator.shared.evaluateExpression(from: infixExpression)
        
        XCTAssert(result.isNaN, "wrong equetion return NaN")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
