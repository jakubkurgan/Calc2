//
//  KeyCell.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var highlightedView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTitleLabelLayout()
        setuphighlightedViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlightedView.isHidden = !isHighlighted
        }
    }
    
    // MARK: - Setup
    
    private func setupTitleLabelLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5).isActive = true
    }
    
    private func setuphighlightedViewLayout() {
        contentView.addSubview(highlightedView)
        highlightedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.5).isActive = true
        highlightedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.5).isActive = true
        highlightedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.5).isActive = true
        highlightedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5).isActive = true
        highlightedView.isHidden = true 
    }
    
    func setupTitleLabel(title: String, textColor: UIColor, backgroundColor: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.backgroundColor = backgroundColor
    }
}
