//
//  NewsStoryTableViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/10/22.
//

import UIKit

class NewsStoryTableViewCell: UITableViewCell {
    static let identifier = "NewsStoryTableViewCell"
    
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageURL: URL?
        
        init(model: NewsStory) {
            source = model.source
            headline = model.headline
            dateString = "Jun 21, 2021"
            imageURL = nil
        }
    }
    
//    MARK: - Subviews
    
//    Source
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
//    Headline
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
//    Date
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
//    Image
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
        
//    MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        backgroundColor = nil
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.h - 6
        
        storyImageView.frame = CGRect(
            x: contentView.w - imageSize - 10,
            y: 3,
            width: imageSize,
            height: imageSize
        )
        
//        Layout labels
        let availableWidth: CGFloat = contentView.w - separatorInset.left - imageSize - 15
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: separatorInset.left,
            y: 4,
            width: availableWidth,
            height: sourceLabel.h
        )
        
        headlineLabel.frame = CGRect(
            x: separatorInset.left,
            y: sourceLabel.b + 5,
            width: availableWidth,
            height: contentView.h - sourceLabel.b - dateLabel.h - 10
        )

        dateLabel.frame = CGRect(
            x: separatorInset.left,
            y: contentView.h - 40,
            width: availableWidth,
            height: 40
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }

//    MARK: - Public
    
    public func configure(with viewModel: ViewModel) {
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
        storyImageView.image = nil
    }
}
