//
//  CalcViewModel.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

class CalcViewModel {
    
    // MARK: - Properties
    
    private(set) var keyboardDataList: [KeyCellData] = []
    
    // MARK: - Init
    
    init() {
        setupKeyboardDataList()
    }
    
    // MARK: - Setup Keyboard Data
    
    private func setupKeyboardDataList() {
        keyboardDataList = [KeyCellData(title: "C", actionBlock: nil),
                            KeyCellData(title: "(", actionBlock: nil),
                            KeyCellData(title: ")", actionBlock: nil),
                            KeyCellData(title: "÷", actionBlock: nil),
            
                            KeyCellData(title: "7", actionBlock: nil),
                            KeyCellData(title: "8", actionBlock: nil),
                            KeyCellData(title: "9", actionBlock: nil),
                            KeyCellData(title: "x", actionBlock: nil),
                            
                            KeyCellData(title: "4", actionBlock: nil),
                            KeyCellData(title: "5", actionBlock: nil),
                            KeyCellData(title: "6", actionBlock: nil),
                            KeyCellData(title: "-", actionBlock: nil),
                            
                            KeyCellData(title: "1", actionBlock: nil),
                            KeyCellData(title: "2", actionBlock: nil),
                            KeyCellData(title: "3", actionBlock: nil),
                            KeyCellData(title: "+", actionBlock: nil),
                            
                            KeyCellData(title: "", actionBlock: nil),
                            KeyCellData(title: "0", actionBlock: nil),
                            KeyCellData(title: ".", actionBlock: nil),
                            KeyCellData(title: "=", actionBlock: nil)]
    }
}
