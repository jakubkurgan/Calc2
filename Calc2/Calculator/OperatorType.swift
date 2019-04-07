//
//  OperatorType.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

enum OperatorType: CustomStringConvertible {
    case add
    case subtract
    case divide
    case multiply
    
    var description: String {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .divide:
            return "/"
        case .multiply:
            return "*"
        }
    }
}
