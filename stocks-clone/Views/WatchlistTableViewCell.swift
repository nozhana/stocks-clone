//
//  WatchlistTableViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/17/22.
//

import UIKit

protocol WatchlistTableViewCellDelegate: AnyObject {
    func didSetMaxCellRightContentWidth()
}

/// A cell view that represents a watchlist item.
///
/// **Identifier:** `WatchlistTableViewCell`
final class WatchlistTableViewCell: UITableViewCell {
    
    /// The ``WatchlistTableViewCell`` reuse identifier.
    static let identifier = "WatchlistTableViewCell"
    
    weak var delegate: WatchlistTableViewCellDelegate?
    
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
        let companyName: String
        let price: String // Formatted
        let changePercentage: String // Formatted
        let changeColor: UIColor // red or green
        let change: String // Formatted
        let chartViewModel: StockChartView.ViewModel
    }
    
//    MARK: - Init
    
    /// Adds subviews when the view initializes.
    /// - Parameters:
    ///   - style: `CellStyle`.
    ///   - reuseIdentifier: `String`.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
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
    
    /// Lays out subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.sizeToFit()
        companyLabel.sizeToFit()
        priceLabel.sizeToFit()
        changePercentageLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        priceLabel.textAlignment = .right
        changePercentageLabel.textAlignment = .right
        changeLabel.textAlignment = .right
        
        /// The vertical distance between content elements
        let verticalDistance: CGFloat = 4
        
        /// The horizontal distance between content elements
        let horizontalDistance: CGFloat = 8
        
        /// The distance from the content's right to the frame's right
        let rightMargin: CGFloat = 16
        
        /// The distance from the content's top to the frame's top
        let topMargin: CGFloat = 8
        
        /// Min y for left-aligned content within the cell
        let leftContentTop: CGFloat = (contentView.h - symbolLabel.h - companyLabel.h - verticalDistance) / 2
        
        /// Min y for right-aligned content within the cell
        let rightContentTop: CGFloat = (contentView.h - priceLabel.h - changePercentageLabel.h - changeLabel.h - verticalDistance) / 2
        
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
        
        /// Max width of right-aligned content among all cells up to the current cell
        let currentRightContentWidth = max(
            max(priceLabel.w, changePercentageLabel.w),
            WatchListViewController.maxCellRightContentWidth
        )
        
        // Assigns the maxCellRightContentWidth to currentRightContentWidth
        // if the current width is larger
        if currentRightContentWidth > WatchListViewController.maxCellRightContentWidth {
            WatchListViewController.maxCellRightContentWidth = currentRightContentWidth
            delegate?.didSetMaxCellRightContentWidth()
        }
        
        priceLabel.frame = .init(
            x: contentView.w - currentRightContentWidth - rightMargin,
            y: rightContentTop,
            width: currentRightContentWidth,
            height: priceLabel.h
        )
        
        changePercentageLabel.frame = .init(
            x: contentView.w - currentRightContentWidth - rightMargin,
            y: priceLabel.b + verticalDistance,
            width: currentRightContentWidth,
            height: changePercentageLabel.h
        )
        
        changeLabel.frame = .init(
            x: contentView.w - currentRightContentWidth - rightMargin,
            y: changePercentageLabel.b,
            width: currentRightContentWidth,
            height: changeLabel.h
        )
        
        miniChartView.frame = .init(
            x: priceLabel.l - miniChartView.w - horizontalDistance,
            y: topMargin,
            width: contentView.w / 3,
            height: contentView.h - (topMargin * 2)
        )
    }
    
    /// Deconstructs all subviews accordingly and prepares the view for reuse.
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
    
    /// The label that represents the percentage of changed value for the stock since prior candle
    private let changePercentageLabel: UILabel = {
        let label = PaddingLabel(top: 2, left: 4, bottom: 2, right: 4)
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    /// The label that represents the changed value for the stock since last closing price.
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// The minichart that represents the stock price history.
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.clipsToBounds = true
        chart.isUserInteractionEnabled = false
        return chart
    }()
   
//    MARK: - Public
    
    /// Configures the cell subviews with given ViewModel.
    /// - Parameter viewModel: A ``ViewModel`` that holds information related to a specific stock to populate the cell.
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changePercentageLabel.text = viewModel.changePercentage
        changePercentageLabel.backgroundColor = viewModel.changeColor
        changeLabel.text = viewModel.change
        miniChartView.configure(with: viewModel.chartViewModel)
    }
}
