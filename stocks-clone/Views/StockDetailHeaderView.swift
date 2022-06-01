//
//  StockDetailHeaderView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/31/22.
//

import UIKit

class StockDetailHeaderView: UIView {
    
//    MARK: - Properties

    private let metricViewModels: [MetricCollectionViewCell.ViewModel] = []
    
//    Subviews
    private let chartView: StockChartView = {
        let chartView = StockChartView()
        chartView.backgroundColor = .link
        return chartView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        Register cells
        collectionView.register(
            MetricCollectionViewCell.self,
            forCellWithReuseIdentifier: MetricCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
//    MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        addSubviews(chartView, collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chartView.frame = CGRect(x: 0, y: 0, width: w, height: h - 100)
        collectionView.frame = CGRect(x: 0, y: h - 100, width: w, height: 100)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        metricViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = metricViewModels[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MetricCollectionViewCell.identifier,
            for: indexPath
        ) as? MetricCollectionViewCell else {
            fatalError("MetricCollectionViewCell can't be dequeued for collectionView")
        }
        
        cell.configure(with: viewModel)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: w / 2, height: h / 3)
    }
}
