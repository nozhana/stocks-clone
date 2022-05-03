//
//  SearchResultsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
//    MARK: - Properties

    private let tableView: UITableView = {
        let table = UITableView()
//        Register a cell
        table.register(SearchResultsTableViewCell.self,
                       forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        return table
    }()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
//    MARK: - Private
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        TODO: Pass real numberOfRows from API
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultsTableViewCell.identifier,
            for: indexPath
        )
        
//        TODO: Pass real stocks from API
        cell.textLabel?.text = "AAPL"
        cell.detailTextLabel?.text = "Apple Inc."
        
        return cell
        
    }
    
    
}
