//
//  Stack.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

struct Stack<T> {
    private var array = [T]()
    
    init() {
        
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    var top: T? {
        return array.last
    }
}

extension Stack: Sequence {
    func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
}
