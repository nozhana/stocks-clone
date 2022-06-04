//
//  MetricCollectionViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 6/1/22.
//

import UIKit

class MetricCollectionViewCell: UICollectionViewCell {
//    MARK: - Properties
    
    static let identifier = "MetricCollectionViewCell"
    
    struct ViewModel {
        internal init(name: String, value: Double) {
            self.name = name
            self.value = "\(value.rounded(to: 2))"
        }
        
        let name: String
        let value: String
    }
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        
        return nameLabel
    }()
    
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textColor = .secondaryLabel
        valueLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        return valueLabel
    }()
    
//    MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
//    MARK: - Private
    
//    MARK: - Public
    
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value
    }
}
