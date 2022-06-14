//
//  SearchResultsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidSelect(result: SearchResult)
}
// MARK: -

/// The view controller that manages search results within symbols API. Implemented in the watchlistVC
class SearchResultsViewController: UIViewController {
    
    /// SearchResultsVC delegate. Used to handle actions after selecting a result.
    weak var delegate: SearchResultsViewControllerDelegate?
    
    /// Array of ``SearchResult`` that holds the results of search API call
    private var results: [SearchResult] = []
    
    /// TableView to display search results
    private let tableView: UITableView = {
        let table = UITableView()
        
//        Register a cell
        table.register(SearchResultsTableViewCell.self,
                       forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        
        table.isHidden = true
        
        return table
    }()
    
//    MARK: - Lifecycle
    
    /// Sets up the view after it finishes loading
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    /// Called after view finished laying out subviews. Used to maximize the tableView frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
//    MARK: - Private
    
    /// Sets up the tableView and adds it to the view's subviews.
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    MARK: - Public
    
    /// Updates the tableView with results from API call
    /// - Parameter results: Array of ``SearchResult``
    public func update(with results: [SearchResult]) {
        self.results = results
        
//        Hide tableView unless results exist
        tableView.isHidden = results.isEmpty
        
        tableView.reloadData()
    }
    
}

// MARK: - TableView Delegate/Datasource
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultsTableViewCell.identifier,
            for: indexPath
        )
        
        let result = results[indexPath.row]
        
        cell.textLabel?.text = result.displaySymbol
        cell.detailTextLabel?.text = result.description
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = results[indexPath.row]
        delegate?.searchResultsViewControllerDidSelect(result: result)
    }
    
    
}
