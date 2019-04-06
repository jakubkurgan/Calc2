//
//  CalcViewController.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Calc2"
    }

}
