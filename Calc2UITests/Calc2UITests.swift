//
//  Calc2UITests.swift
//  Calc2UITests
//
//  Created by Jakub Kurgan on 14/04/2019.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import XCTest

class Calc2UITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    func testAddition() {
        let expression = "2 + 3 ="
        
        pressKeysFromExpression(expression)
        let result = XCUIApplication().textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "2 + 3\n = 5")
    }
    
    func testAdditionAndMultiplyThousands() {
        let expression = "1024 + 3 * 999999 ="
        
        pressKeysFromExpression(expression)
        let result = XCUIApplication().textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "1,024 + 3 * 999,999\n = 3,001,021")
    }
    
    func testSubstractingDecimals() {
        let expression = "4.1 - 3.2 ="
        
        pressKeysFromExpression(expression)
        let result = XCUIApplication().textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "4.1 - 3.2\n = 0.90")
    }
    
    func testEquationOrder() {
        let expression = "2 + 2 * 2 ="
        
        pressKeysFromExpression(expression)
        let result = XCUIApplication().textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "2 + 2 * 2\n = 6")
    }
    
    func testtEquationOrderWithParanteses() {
        let expression = "( 2 + 2 ) * 2 ="
        
        pressKeysFromExpression(expression)
        let result = XCUIApplication().textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "( 2 + 2 ) * 2\n = 8")
    }
    
    func testBigNumbers() {
        let expression = "1000000000000000 * 123456789 / 987654321 ="
        
        pressKeysFromExpression(expression)
        let result = XCUIApplication().textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "1,000,000,000,000,000 * 123,456,789 / 987,654,321\n = 124,999,998,860,937.50")
    }
    
    func testDeleteButton() {
        let expression = "10 * 12"
        let app = XCUIApplication()
        
        pressKeysFromExpression(expression)
        app.staticTexts["del"].press(forDuration: 0.3)
        app.staticTexts["="].press(forDuration: 0.3)

        let result = app.textViews["resultTextView"].value as? String

        XCTAssertEqual(result, "10 * 1\n = 10")
    }
    
    func testClearButton() {
        let expression = "13 * 1024 = "
        let app = XCUIApplication()
        
        pressKeysFromExpression(expression)
        app.staticTexts["C"].press(forDuration: 0.3)
        
        let result = app.textViews["resultTextView"].value as? String
        XCTAssertEqual(result, "")
    }
    
    
    func pressKeysFromExpression(_ expression: String) {
        let app = XCUIApplication()
        
        expression.components(separatedBy: " ").forEach { (key) in
            key.forEach({ (char) in
                app.staticTexts[String(char)].press(forDuration: 0.3)
            })
        }
    }

}
