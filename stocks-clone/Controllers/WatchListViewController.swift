//
//  WatchListViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit

class WatchListViewController: UIViewController {

//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTitle()
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
        
//        TODO: Call API to search
        APIManager.shared.search(query: query) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    resultsVC.update(with: response.result)
                }
            case .failure(let error):
                print(error)
            }
        }
        
//        TODO: Update results controller after search
        
    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(result: SearchResult) {
//        TODO: Present stock details for selection
        print("Did select: \(result.displaySymbol)")
    }
}
