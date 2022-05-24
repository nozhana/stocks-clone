//
//  WatchlistTableViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/17/22.
//

import UIKit

/// A cell view that represents a watchlist item.
///
/// **Identifier:** `WatchlistTableViewCell`
class WatchlistTableViewCell: UITableViewCell {
    
    /// The ``WatchlistTableViewCell`` reuse identifier.
    static let identifier = "WatchlistTableViewCell"
    
    /// The preferred height of the ``WatchlistTableViewCell``.
    ///
    /// Defaults to 140.
    static let preferredHeight: CGFloat = 80
    
    /// The ViewModel that structures the data represented in the ``WatchlistTableViewCell``.
    ///
    /// - **Members**:
    ///   - `symbol: String`
    ///   - `company: String`
    ///   - `price: String` (decimal formatted)
    ///   - `changePercentage: String` (percent formatted)
    ///   - `changeColor: UIColor`
    ///     - `.systemRed` for negative change
    ///     - `.systemGreen` for positive change
    ///   - `change: String` (decimal formatted)
    ///   - **TODO:** `chartViewModel`
    struct ViewModel {
        let symbol: String
        let company: String
        let price: String // Formatted
        let changePercentage: String // Formatted
        let changeColor: UIColor // red or green
        let change: String // Formatted
//        TODO: let chartViewModel: StockChartView.ViewModel
    }
    
//    MARK: - Init
    
    /// Adds subviews when the view initializes.
    /// - Parameters:
    ///   - style: `CellStyle`.
    ///   - reuseIdentifier: `String`.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(
            symbolLabel,
            companyLabel,
            priceLabel,
            changePercentageLabel,
            changeLabel,
            miniChartView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.sizeToFit()
        companyLabel.sizeToFit()
        priceLabel.sizeToFit()
        changePercentageLabel.sizeToFit()
        changeLabel.sizeToFit()
        miniChartView.sizeToFit()
        
        let verticalDistance: CGFloat = 4
        let horizontalDistance: CGFloat = 10
        let rightMargin: CGFloat = 16
        let leftContentTop: CGFloat = (contentView.h - symbolLabel.h - companyLabel.h - verticalDistance) / 2
        let rightContentTop: CGFloat = (contentView.h - priceLabel.h - changePercentageLabel.h - verticalDistance) / 2
        
        symbolLabel.frame = .init(
            x: separatorInset.left,
            y: leftContentTop,
            width: symbolLabel.w,
            height: symbolLabel.h
        )
        
        companyLabel.frame = .init(
            x: separatorInset.left,
            y: symbolLabel.b + verticalDistance,
            width: companyLabel.w,
            height: companyLabel.h
        )
        
        priceLabel.frame = .init(
            x: contentView.r - priceLabel.w - rightMargin,
            y: rightContentTop,
            width: priceLabel.w,
            height: priceLabel.h
        )
        
        changePercentageLabel.frame = .init(
            x: contentView.r - changePercentageLabel.w - rightMargin,
            y: priceLabel.b + verticalDistance,
            width: changePercentageLabel.w,
            height: changePercentageLabel.h
        )
        
        changeLabel.frame = .init(
            x: changePercentageLabel.l - changeLabel.w - horizontalDistance,
            y: changePercentageLabel.b - changeLabel.h,
            width: changeLabel.w,
            height: changeLabel.h
        )
    }
    
    /// Deconstruct all subviews accordingly.
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyLabel.text = nil
        priceLabel.text = nil
        changePercentageLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset() // Stubbed
    }
    
//    MARK: - Private
    
    /// The label that represents the stock symbol.
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    /// The label that represents the name of the company.
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    /// The label that represents the current price of the stock.
    private let priceLabel: UILabel = {
        let label = UILabel()
//        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let changePercentageLabel: UILabel = {
        let label = UILabel()
//        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    /// The label that represents the changed value of the stock since last closing price.
    private let changeLabel: UILabel = {
        let label = UILabel()
//        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// The minichart that represents the stock price history.
    private let miniChartView = StockChartView()
   
//    MARK: - Public
    
    /// Configures the cell subviews with given ViewModel.
    /// - Parameter viewModel: A ``ViewModel`` that holds information related to a specific stock to populate the cell.
    ///
    /// **TODO:** Configure minichart.
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.company
        priceLabel.text = viewModel.price
        changePercentageLabel.text = viewModel.changePercentage
        changePercentageLabel.backgroundColor = viewModel.changeColor
        changeLabel.text = viewModel.change
//        TODO: Configure chart
    }
    
}
