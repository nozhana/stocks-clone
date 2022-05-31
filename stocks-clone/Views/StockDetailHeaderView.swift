//
//  StockDetailHeaderView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/31/22.
//

import UIKit

class StockDetailHeaderView: UIView {
    
//    MARK: - Properties

//    Chart View
    private let chartView = StockChartView()
    
//    Collection View
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        
//        Register cells
        
        return collectionView
    }()
    
//    MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(chartView, collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
//    MARK: - Public
    
    public func configure(
        chartViewModel: StockChartView.ViewModel // TODO: Also FinancialMetrics ViewModels
    ) {
        
    }
}

// MARK: - Extensions

// MARK: - CollectionView

extension StockDetailHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: w / 2, height: h / 3)
    }
}
