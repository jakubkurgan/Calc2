//
//  KeyCellData.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

struct KeyCellData {
    let keyType: KeyType
    let keyStyle: KeyStyle
    
    init(keyType: KeyType) {
        self.keyType = keyType
        
        switch keyType {
        case .token(let token):
            if token.isOperand {
                self.keyStyle = KeyStyle(textColor: .gray, backgroundColor: .white)
            } else {
                self.keyStyle = KeyStyle(textColor: .orange, backgroundColor: .white)
            }
        case .evaluate:
            self.keyStyle = KeyStyle(textColor: .white, backgroundColor: .orange)
        case .clear, .delete:
            self.keyStyle = KeyStyle(textColor: .orange, backgroundColor: .white)
        }
    }
}
