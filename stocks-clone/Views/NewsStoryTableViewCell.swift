//
//  NewsStoryTableViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/10/22.
//

import SDWebImage
import UIKit

/// A `UITableViewCell` for a news story
class NewsStoryTableViewCell: UITableViewCell {
    /// NewsStoryTableViewCell reuse identifier
    static let identifier = "NewsStoryTableViewCell"
    
    /// Preferred height to display in tableview
    static let preferredHeight: CGFloat = 120
    
    /// NewsStoryTableViewCell ViewModel.
    ///
    /// Contains:
    /// - source: String
    /// - headline: String
    /// - dateString: String
    /// - imageURL: URL?
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageURL: URL?
        
        /// Custom memberwise initializer for this ViewModel
        /// - Parameter model: ``NewsStory`` to initialize this ViewModel
        init(model: NewsStory) {
            source = model.source
            headline = model.headline
            dateString = .prettyDateString(from: model.datetime)
            imageURL = URL(string: model.image)
        }
    }
    
//    MARK: - Subviews
    
    /// The label that displays the news source
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .heavy).serif
        return label
    }()
    
    /// The label that displays the news headline
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium).condensed
        label.numberOfLines = 0
        return label
    }()
    
    /// The label that displays a pretty date
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// The `UIImageView` that displays the news story image
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
        
//    MARK: - Init
    
    /// Initializes the NewsStoryTableViewCell and adds subviews
    /// - Parameters:
    ///   - style: `CellStyle`
    ///   - reuseIdentifier: ``identifier
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Lays out subviews in NewsStoryTableViewCell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// The width of the NewsStory image
        let imageSize: CGFloat = contentView.h - 18
        
        storyImageView.frame = CGRect(
            x: contentView.w - imageSize - 10,
            y: (contentView.h - imageSize) / 2,
            width: imageSize,
            height: imageSize
        )
        
        /// Available width after laying out the image
        let availableWidth: CGFloat = contentView.w - separatorInset.left - imageSize - 15
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: separatorInset.left,
            y: 4,
            width: availableWidth,
            height: sourceLabel.h
        )
        
        dateLabel.frame = CGRect(
            x: separatorInset.left,
            y: contentView.h - 40,
            width: availableWidth,
            height: 40
        )

        headlineLabel.frame = CGRect(
            x: separatorInset.left,
            y: sourceLabel.b + 5,
            width: availableWidth,
            height: contentView.h - sourceLabel.b - dateLabel.h - 15
        )

    }
    
    /// Nils out the subviews' contents and prepares the cell for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }

//    MARK: - Public
    
    /// Configures the NewsStoryTableViewCell with its viewmodel
    /// - Parameter viewModel: viewmodel to configure with
    public func configure(with viewModel: ViewModel) {
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageURL)
//        Manually set image from url
//        storyImageView.setImage(with: viewModel.imageURL)
    }
}
