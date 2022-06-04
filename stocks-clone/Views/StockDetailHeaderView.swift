//
//  StockDetailHeaderView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/31/22.
//

import UIKit

class StockDetailHeaderView: UIView {
    
//    MARK: - Properties

    private var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
    
    private let collectionViewHeight: CGFloat = 100
    
//    Subviews
    private let chartView: StockChartView = {
        let chartView = StockChartView()
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
        
        collectionView.backgroundColor = .secondarySystemBackground
        
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
        
        chartView.frame = CGRect(x: 0, y: 0, width: w, height: h - collectionViewHeight)
        collectionView.frame = CGRect(x: 0, y: h - collectionViewHeight, width: w, height: collectionViewHeight)
    }
    
//    MARK: - Public
    
    public func configure(
        chartViewModel: StockChartView.ViewModel,
        metricViewModels: [MetricCollectionViewCell.ViewModel]
    ) {
//        Update chart
        chartView.configure(with: chartViewModel)
        
//        Update metrics
        self.metricViewModels = metricViewModels
        collectionView.reloadData()
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
        CGSize(width: w / 2, height: collectionViewHeight / 3)
    }
}
