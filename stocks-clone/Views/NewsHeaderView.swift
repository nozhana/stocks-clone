//
//  NewsHeaderView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/9/22.
//

import UIKit

/// The delegate for NewsHeaderView.
/// Used to manage tapping the "Add to watchlist" button.
protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidTapAddButton (_ headerView: NewsHeaderView)
}

/// A `UITableViewHeaderFooterView` for the news panel.
class NewsHeaderView: UITableViewHeaderFooterView {
    /// NewsHeaderView reuse identifier
    static let identifier = "NewsHeaderView"
    /// Preferred height to display in table
    static let preferredHeight: CGFloat = 80
    
    /// NewsHeaderViewDelegate instance. Optional
    weak var delegate: NewsHeaderViewDelegate?
    
    /// NewsHeaderView ViewModel.
    ///
    /// Contains a `title: String` and `shouldShowAddButton: Bool`
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    /// Label that displays the title for the news
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .black)
        return label
    }()
    
    /// The "Add to watchlist" button.
    ///
    /// Shows only when the stock currently isn't in the user's watchlist
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
//    MARK: - Init
    
    /// Initializes the NewsHeaderView and adds the label and button as subviews
    /// - Parameter reuseIdentifier: ``identifier``
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Lays out subviews for NewsHeaderView e.g. label and button
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16,
                             y: 0,
                             width: (contentView.w - button.w - (label.l * 2)),
                             height: contentView.h)
        
        button.sizeToFit()
        button.frame = CGRect(x: contentView.w - button.w - 24,
                              y: (contentView.h - button.h) / 2,
                              width: button.w + 16,
                              height: button.h)
    }
    
    /// Nils out the label and prepares the view for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
//    MARK: - Private
    
    /// Called when the user taps the "Add to watchlist" button
    ///
    /// The add button action selector listens to this
    @objc private func didTapAddButton() {
//        Call delegate
        delegate?.newsHeaderViewDidTapAddButton(self)
        button.isHidden = true
    }
    
//    MARK: - Public
    
    /// Configures the NewsHeaderView with its ViewModel
    /// - Parameter viewModel: ViewModel to configure this view with.
    /// Contains a `label` and `shouldShowAddButton`
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
    
}
