//
//  KeyType.swift
//  Calc2
//
//  Created by user914614 on 4/7/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

enum KeyType: CustomStringConvertible {
    case token(Token)
    case evaluate
    case delete
    case clear
    
    var description: String {
        switch self {
        case .token(let token):
            return token.description
        case .evaluate:
            return "="
        case .delete:
            return "del"
        case .clear:
            return "C"
        }
    }
}
