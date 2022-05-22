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
    static let preferredHeight: CGFloat = 140
    
    /// The ViewModel that structures the data represented in the ``WatchlistTableViewCell``.
    ///
    /// - **Members**:
    ///   - `symbol: String`
    ///   - `company: String`
    ///   - `price: String` (decimal formatted)
    ///   - `change: String` (decimal formatted)
    ///   - `changePercentage: String` (percent formatted)
    ///   - `changeColor: UIColor`
    ///     - `.systemRed` for negative change
    ///     - `.systemGreen` for positive change
    ///   - **TODO:** `chartViewModel`
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
    
    /// Adds subviews when the view initializes.
    /// - Parameters:
    ///   - style: `CellStyle`.
    ///   - reuseIdentifier: `String`.
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
    
    /// Deconstruct all subviews accordingly.
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
//    MARK: - Private
    
    /// The label that represents the stock symbol.
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
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
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    /// The label that represents the changed value of the stock since last closing price.
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .white
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
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
//        TODO: Configure chart
    }
    
}
