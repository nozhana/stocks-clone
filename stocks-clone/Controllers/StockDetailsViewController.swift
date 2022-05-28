//
//  StockDetailsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit

class StockDetailsViewController: UIViewController {
    
//    MARK: - Properties
    
    private let symbol: String
    private let companyName: String
    private var candleSticks: [CandleStick]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self,
                           forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return tableView
    }()
    
//    MARK: - Init
    
    init(
        symbol: String,
        companyName: String,
        candleSticks: [CandleStick] = []
    ) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleSticks = candleSticks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        fetchData()
        fetchNews()
    }

//    MARK: - Private
    
    private func setupTable() {
//        TODO: Show view
    }
    
    private func fetchData() {
//        TODO: Fetch financial data
        renderChart()
    }
    
    private func renderChart() {
//        TODO: Show chart
    }
    
    private func fetchNews() {
//        TODO: Fetch news
    }
}
