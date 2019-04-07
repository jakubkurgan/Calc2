//
//  OperatorToken.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

struct OperatorToken: CustomStringConvertible {
    let operatorType: OperatorType
    
    init(operatorType: OperatorType) {
        self.operatorType = operatorType
    }
    
    var precedence: Int {
        switch operatorType {
        case .add, .subtract:
            return 0
        case .divide, .multiply:
            return 1
        }
    }
    
    var description: String {
        return operatorType.description
    }
}
