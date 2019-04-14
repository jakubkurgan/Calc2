//
//  CalculatorError.swift
//  Calc2
//
//  Created by Jakub Kurgan on 14/04/2019.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case wrongEquation
}

extension CalculatorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongEquation:
            return "wrongEquationErrorMessage".localized
        }
    }
}
