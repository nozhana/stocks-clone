//
//  WatchListViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit

class WatchListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
    }
    
    private func setupSearchController () {
        let resultsVC = SearchResultsViewController()
        let searchVC = UISearchController(searchResultsController: resultsVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }


}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        Don't run if search bar is empty or search results are inaccessible
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }
        
//        TODO: Reduce API calls to when user finishes typing
        print(query)
        
//        TODO: Update results controller after search
        
    }
}
