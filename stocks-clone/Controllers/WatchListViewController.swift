//
//  WatchListViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    
    private var panelVC: FloatingPanelController?
    
    private var watchlistMap: [String: [String]] = [:]
    
//    private let persistenceManager = PersistenceManager.shared
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchlistTableViewCell.self,
                           forCellReuseIdentifier: WatchlistTableViewCell.identifier)
        return tableView
    }()
    
    private var searchTimer: Timer?

//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTitle()
        setupSearchController()
        setupTableView()
        setupWatchlistData()
        setupFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
//    MARK: - Private
    
    private func setupTitle() {
        title = "Stocks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupSearchController() {
        let resultsVC = SearchResultsViewController()
        resultsVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultsVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupWatchlistData() {
        let symbols = PersistenceManager.shared.watchlistSymbols
        for symbol in symbols {
//            TODO: Fetch market data for symbol
            watchlistMap[symbol] = ["Some string here"]
        }
    }
    
    private func setupFloatingPanel() {
        let newsVC = NewsViewController(type: .topStories)
        panelVC = FloatingPanelController(delegate: self)
        panelVC?.surfaceView.backgroundColor = .secondarySystemBackground
        panelVC?.set(contentViewController: newsVC)
        panelVC?.track(scrollView: newsVC.tableView)
        panelVC?.addPanel(toParent: self)
    }
}

// MARK: - Extensions

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        Don't run if search bar is empty or search results are inaccessible
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }
        
//        TODO: Optimize to reduce calls to when user finishes typing
        print(query)
        
//        Reset Timer
        searchTimer?.invalidate()
        
//        Kick off new timer when user taps
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            APIManager.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.result)
                    }
                case .failure(let error):
//                    Empty results view when error occurs
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })
    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(result: SearchResult) {
//        Hide keyboard after selection
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        let detailVC = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: detailVC)
        detailVC.title = result.description
        present(navVC, animated: true)
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        watchlistMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WatchlistTableViewCell.identifier,
            for: indexPath
        )
        
        cell.textLabel?.text = watchlistMap.keys[watchlistMap.keys.index(watchlistMap.keys.startIndex, offsetBy: indexPath.row)]
        cell.detailTextLabel?.text = watchlistMap[cell.textLabel?.text ?? ""]?[0]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        TODO: Open details for selection
    }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        navigationController?.setNavigationBarHidden(state == .full, animated: true)
    }
}
