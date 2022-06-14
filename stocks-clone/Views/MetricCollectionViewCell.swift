//
//  MetricCollectionViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 6/1/22.
//

import UIKit

/// A reusable cell for the collectionView used to represent stock metrics.
class MetricCollectionViewCell: UICollectionViewCell {
//    MARK: - Properties
    
    /// The ``MetricCollectionViewCell`` reuse identifier.
    static let identifier = "MetricCollectionViewCell"
    
    /// The ``MetricCollectionViewCell`` ViewModel.
    ///
    /// Comprises:
    /// - `name: String`
    /// - `value: Double`
    ///
    /// - Note: Memberwise initializer rounds the value to 2 fractional digits.
    struct ViewModel {
        internal init(name: String, value: Double) {
            self.name = name
            self.value = "\(value.rounded(to: 2))"
        }
        
        let name: String
        let value: String
    }
    
    /// The label used to represent the title of the cell.
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        
        return nameLabel
    }()
    
    /// The label used to represent the value of the cell.
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textColor = .secondaryLabel
        valueLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        return valueLabel
    }()
    
//    MARK: - Init
    
    /// Initializes the cell and adds the subviews.
    ///
    /// clips the contentView to bounds.
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Lays out the subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.sizeToFit()
        valueLabel.sizeToFit()
        
        let horizontalMargin: CGFloat = 16
        
        nameLabel.frame = CGRect(
            x: horizontalMargin,
            y: (contentView.h - nameLabel.h) / 2,
            width: nameLabel.w,
            height: nameLabel.h
        )
        
        valueLabel.frame = CGRect(
            x: contentView.w - horizontalMargin - valueLabel.w,
            y: (contentView.h - valueLabel.h) / 2,
            width: valueLabel.w,
            height: valueLabel.h
        )
    }
    
    /// Nils out the subviews and prepares the cell for reuse.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
//    MARK: - Private
    
//    MARK: - Public
    
    /// Configures the cell with a ``ViewModel``.
    /// - Parameter viewModel: A ``ViewModel`` containing a `name` and `value`.
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value
    }
}
