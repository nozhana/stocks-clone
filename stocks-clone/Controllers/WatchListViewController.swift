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
    
    private var searchTimer: Timer?

//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTitle()
        setupFloatingPanel()
    }
    
//    MARK: - Private
    private func setupSearchController() {
        let resultsVC = SearchResultsViewController()
        resultsVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultsVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    private func setupTitle() {
        title = "Stocks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupFloatingPanel() {
        let newsVC = TopStoriesNewsViewController()
        panelVC = FloatingPanelController(delegate: self)
        panelVC?.surfaceView.backgroundColor = .secondarySystemBackground
        panelVC?.set(contentViewController: newsVC)
        panelVC?.track(scrollView: newsVC.tableView)
        panelVC?.addPanel(toParent: self)
    }


}

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

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        navigationController?.setNavigationBarHidden(state == .full, animated: true)
    }
}
