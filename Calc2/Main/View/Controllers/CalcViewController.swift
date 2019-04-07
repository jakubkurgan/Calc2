//
//  CalcViewController.swift
//  Calc2
//
//  Created by user914614 on 4/6/19.
//  Copyright © 2019 Jakub Kurgan. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .right
        textView.textContainerInset = UIEdgeInsets(top: (view.frame.height * 2/5) - 20, left: 0, bottom: 20, right: 20)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 40)
        textView.isEditable = false
        textView.setContentOffset(CGPoint(x: 0, y: textView.contentSize.height - textView.bounds.height), animated: false)

        return textView
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .gray
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: String(describing: KeyCell.reuseIdentifier))
        return collectionView
    }()

    // MARK: - Properties
    
    private let viewModel = CalcViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.observer = self
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        title = "projectTitle".localized
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        setupCollectionViewLayout()
        setupTextViewLayout()
    }
    
    private func setupTextViewLayout() {
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
    }
    
    private func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/5).isActive = true
    }
}

// MARK: - CollectionView

extension CalcViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.keyboardDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.reuseIdentifier, for: indexPath) as? KeyCell {
            
            let data = viewModel.keyboardDataList[indexPath.item]
            cell.setupTitleLabel(title: data.keyType.description,
                                 textColor: data.keyStyle.textColor,
                                 backgroundColor: data.keyStyle.backgroundColor)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.keyboardDataList[indexPath.item]
        
        viewModel.keyTapped(with: data.keyType)
    }
}

// MARK: - CollectionView FlowLayout

extension CalcViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 4, height: collectionView.bounds.height / 5)
    }
}

// MARK: - Observer text didChange

extension CalcViewController: CalcViewControllerObserver {
    func observer(didChange text: String) {
        textView.text = text
        textView.setContentOffset(CGPoint(x: 0, y: textView.contentSize.height - textView.bounds.height), animated: false)
    }
}
