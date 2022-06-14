//
//  NewsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import SafariServices
import UIKit

/// A view controller that manages the market news for generic and specific purposes in a table.
class NewsViewController: UIViewController {
    
    /// An enum representing the type of content to render in the view.
    ///
    /// Could be `.topStories` or `.companyNews(symbol:)`
    enum contentType {
        case topStories
        case companyNews(symbol: String)
        
        /// The view title that represents "Top Stories" if the news category is generic,
        /// otherwise it will represent the uppercased symbol correlated with the given query.
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .companyNews(let symbol):
                return symbol.uppercased()
            }
        }
    }
    
//    MARK: - Properties
    
    /// An array of ``NewsStory`` prepopulated with mock data.
    private var stories: [NewsStory] = [
        NewsStory(
            category: "",
            datetime: 123,
            headline: "Loading...",
            id: 123,
            image: "",
            related: "",
            source: "",
            summary: "",
            url: ""
        )
    ]
    
    /// The type of content this view controller represents.
    private var type: contentType
    
    /// The `UITableView` embedded in this controller.
    ///
    /// The cells are of type ``NewsStoryTableViewCell``.
    ///
    /// The header is of type ``NewsHeaderView``.
    ///
    /// The background color is set to `.clear`.
    let tableView: UITableView = {
        let table = UITableView()
//        Register cell, header
        table.register(NewsHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self,
                       forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        table.backgroundColor = .clear
        return table
    }()
    
        
//    MARK: - Init
    
    /// Initializes the ``NewsViewController`` with a ``contentType``.
    /// - Parameter type: Could be ``contentType/topStories`` or ``contentType/companyNews(symbol:)``
    init(type: contentType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    MARK: - Lifecycle
    
    /// Sets up the table and fetches the news after the view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchNews()
    }
    
    /// Adjusts the ``tableView`` frame to match this view's bounds after laying out subviews.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
//    MARK: - Private
    
    /// Adds the ``tableView`` as subview and assign its `delegate` and `dataSource` to self.
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Calls API endpoint ``APIManager/news(for:completion:)`` with `type` property.
    ///
    /// Assigns `stories` property to the ``NewsStory`` array in API call completion handler.
    private func fetchNews() {
        APIManager.shared.news(for: type) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self.stories = stories
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Opens given URL in a Safari view.
    /// - Parameter url: URL literal to open in `SFSafariViewController`.
    ///
    /// Prefers entering reader mode.
    private func open(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
        
    }
    
    /// Presents an alert that notifies the user that the URL passed in `open(url:)` failed to open.
    private func presentFailedToOpenAlert() {
        HapticsManager.shared.vibrateForNotification(type: .error)
        
        let alertVC = UIAlertController(
            title: "Error",
            message: "Failed to open webpage.\nPlease try again.",
            preferredStyle: .alert
        )
        
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        present(alertVC, animated: true)
    }
    
}

// MARK: - Extensions: Configure tableView

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsStoryTableViewCell.identifier,
            for: indexPath
        ) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.identifier
        ) as? NewsHeaderView else {
            return nil
        }
        header.configure(with: .init(
            title: type.title,
            shouldShowAddButton: false
        ))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let story = stories[indexPath.row]
        
        guard let url = URL(string: story.url) else {
            presentFailedToOpenAlert()
            return
        }
        
        open(url: url)
    }
    
}
