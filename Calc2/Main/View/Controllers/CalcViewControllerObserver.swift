//
//  CalcViewControllerObserver.swift
//  Calc2
//
//  Created by user914614 on 4/7/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import Foundation

protocol CalcViewControllerObserver: class {
    func observer(didChange text: String)
}
