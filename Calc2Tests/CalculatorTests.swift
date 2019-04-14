//
//  Calc2Tests.swift
//  Calc2Tests
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import XCTest
@testable import Calc2

class CalculatorTests: XCTestCase {

    func testSimpleAddition() {
        let infixExpression: [Token] = [Token(operand: 20),
                                        Token(operatorType: .add),
                                        Token(operand: 2)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTAssertEqual(token.operand?.decimal, 22, "\(infixExpression.description)")
            case .failure(let error):
                
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testEquationOrder() {
        let infixExpression: [Token] = [Token(operand: 2),
                                        Token(operatorType: .add),
                                        Token(operand: 2),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTAssertEqual(token.operand?.decimal, 6, "\(infixExpression.description)")
            case .failure(let error):
                
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testtEquationOrderWithParanteses() {
        let infixExpression: [Token] = [Token(tokenType: .openBracket),
                                        Token(operand: 2),
                                        Token(operatorType: .add),
                                        Token(operand: 2),
                                        Token(tokenType: .closeBracket),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTAssertEqual(token.operand?.decimal, 8, "\(infixExpression.description)")
            case .failure(let error):
                
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testtDecimalAddition() {
        let infixExpression: [Token] = [Token(operand: 2.2),
                                        Token(operatorType: .add),
                                        Token(operand: 9.7),
                                        Token(operatorType: .add),
                                        Token(operand: 3.2)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTAssertNotNil(token.operand)
                XCTAssertEqual(token.operand!.decimal, 15.1, accuracy: 0.000000001, "\(infixExpression)")
            case .failure(let error):
                
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testDecimalMultiplying() {
        let infixExpression: [Token] = [Token(operand: 0.5),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2.2),
                                        Token(operatorType: .multiply),
                                        Token(operand: 10)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTAssertNotNil(token.operand)
                XCTAssertEqual(token.operand!.decimal, 11, accuracy: 0.000000001, "\(infixExpression)")
            case .failure(let error):
                
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testDivideByZeroThrowsError() {
        let infixExpression: [Token] = [Token(operand: 0.5),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2.2),
                                        Token(operatorType: .divide),
                                        Token(operand: 0)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTFail("Division by zero return \(String(describing: token.operand?.decimal))")
            case .failure(let error):
                
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testWrongEquationThrowsError() {
        let infixExpression: [Token] = [Token(operand: 0.5),
                                        Token(operatorType: .multiply),
                                        Token(operand: 2.2),
                                        Token(operatorType: .divide)]
        
        let expectation = XCTestExpectation(description: "evaluateExpression")
        let calculator = Calculator()
        
        calculator.evaluateExpression(from: infixExpression) { (result) in
            switch result {
            case .success(let token):
                
                XCTFail("Wrong equation return \(String(describing: token.operand?.decimal))")
            case .failure(let error):
                
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
