//
//  StockDetailsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit
import SafariServices

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
    
    private var stories: [NewsStory] = []
    
    private var metrics: Metrics?
    
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
        view.backgroundColor = .secondarySystemBackground
        
        setupTable()
        fetchFinancialData()
        fetchNews()
        setupCloseButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

//    MARK: - Private
    
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: view.w,
                height: (view.w * 0.7) + 100
        ))
        tableView.backgroundColor = .clear
    }
    
    private func fetchFinancialData() {
//        TODO: Fetch financial data
        let dispatchGroup = DispatchGroup()
        
//        Fetch candleSticks if needed
        if candleSticks.isEmpty {
            dispatchGroup.enter()
            
        }
        
//        Fetch financial metrics
        dispatchGroup.enter()
        APIManager.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let metricsResponse):
                let metrics = metricsResponse.metric
                self?.metrics = metrics
            case .failure(let error):
                print("Failed to fetch financials from API: \(error)")
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.renderChart()
        }
    }
    
    private func renderChart() {
//        TODO: Show chart
//        Chart VM | FinancialMetricsViewModel(s)
        let headerView = StockDetailHeaderView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.w,
                height: (view.w * 0.7) + 100
            )
        )
        
//        Configure headerView
        var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
        if let metrics = metrics {
            metricViewModels.append(.init(
                name: "52W High",
                value: metrics.fiftyTwoWeekHigh
            ))
            
            metricViewModels.append(.init(
                name: "52W Low",
                value: metrics.fiftyTwoWeekLow
            ))
            
            metricViewModels.append(.init(
                name: "52W Return",
                value: metrics.fiftyTwoWeekPRD
            ))
            
            metricViewModels.append(.init(
                name: "10D Avg. Vol.",
                value: metrics.tenDayAvgVolume
            ))
            
            metricViewModels.append(.init(
                name: "3M Avg. Vol.",
                value: metrics.threeMonthsAvgVolume
            ))
            
            metricViewModels.append(.init(
                name: "Beta",
                value: metrics.beta
            ))
        }
        
        headerView.configure(
            chartViewModel: .init(data: [], showLegend: true, showAxis: true),
            metricViewModels: metricViewModels
        )
        
        tableView.tableHeaderView = headerView
    }
    
    private func fetchNews() {
//        TODO: Fetch news
        APIManager.shared.news(for: .companyNews(symbol: symbol)) { [weak self] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("News Error: \(error)")
            }
        }
    }
}

// MARK: - Protocol conformations

// MARK: - UITableView Delegate/DataSource
extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }
    
//    MARK: Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsStoryTableViewCell.identifier,
            for: indexPath) as? NewsStoryTableViewCell else {
            fatalError("Cell couldn't be cast as NewsStoryTableViewCell")
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: stories[indexPath.row].url) else { return }
        let safariConfig = SFSafariViewController.Configuration()
        safariConfig.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: safariConfig)
        
        present(safariVC, animated: true)
    }
    
//    MARK: Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            fatalError("Header couldn't be cast as NewsHeaderView")
        }
        header.delegate = self
        header.configure(with: .init(
            title: symbol.uppercased(),
            shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol: symbol)
        ))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        NewsHeaderView.preferredHeight
    }
}

// MARK: - NewsHeaderViewDelegate
extension StockDetailsViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {
//        TODO: Add to watchlist
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
        let alert = UIAlertController(title: "Added to Watchlist", message: "We've added \(companyName) (\(symbol)) to your Watchlist.", preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
}
