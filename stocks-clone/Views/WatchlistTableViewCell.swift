//
//  WatchlistTableViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/17/22.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
    
    static let identifier = "WatchlistTableViewCell"
    
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let symbol: String
        let company: String
        let price: String // Formatted
        let change: String // Formatted
        let changePercentage: String // Formatted
        let changeColor: UIColor // red or green
//        TODO: let chartViewModel: StockChartView.ViewModel
    }
    
//    MARK: - Init
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(symbolLabel, companyLabel, priceLabel, changeLabel, miniChartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
//    MARK: - Private
    
//    Symbol label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
//    Company label
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    
//    Price label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    
//    Change label
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .white
        return label
    }()
    
//    Minichart
    private let miniChartView = StockChartView()
   
//    MARK: - Public
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.company
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
//        Configure chart
    }
    
}
