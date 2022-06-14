//
//  StockDetailsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit
import SafariServices

/// View controller that manages the details of a certain stock symbol
class StockDetailsViewController: UIViewController {
    
//    MARK: - Properties
    
    /// The symbol name
    private let symbol: String
    /// The name of the company e.g. description of the symbol
    private let companyName: String
    /// Candlestick data representing the stock. Array of ``CandleStick``
    private var candleSticks: [CandleStick]
    
    /// TableView that displays the chart and metrics in header, and the news in the body.
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self,
                           forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return tableView
    }()
    
    /// Array of ``NewsStory`` for the stock
    private var stories: [NewsStory] = []
    
    /// Optional var of type ``Metrics`` for stock
    private var metrics: Metrics?
    
//    MARK: - Init
    
    /// Initializes StockDetailsVC with a certain stock symbol
    /// - Parameters:
    ///   - symbol: symbol i.e. AAPL
    ///   - companyName: description i.e. Apple Inc.
    ///   - candleSticks: Array of ``CandleStick`` for the stock
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
    
    /// Called when the view finishes loading.
    ///
    /// Sets up the table and the close button, fetches financial data and news for the stock.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupTable()
        fetchFinancialData()
        fetchNews()
        setupCloseButton()
    }
    
    /// Called when the view finished laying out subviews.
    ///
    /// Used to maximize the tableView frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

//    MARK: - Private
    
    /// Sets up the close button on navigation bar
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    /// Dismisses the view when the close button is tapped.
    ///
    /// A `UIBarButtonItem` selector listens to this.
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    /// Sets up the tableView and adds it as a subview.
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
    
    /// Fetches candlesticks and metrics for a certain stock.
    ///
    /// Renders the chart after API call finished executing
    ///
    /// - Note: Only fetches candlesticks if needed e.g. not already present
    /// - Note: Calls API in a dispatch group e.g. asynchronously
    private func fetchFinancialData() {
//        Fetch financial data
        let dispatchGroup = DispatchGroup()
        
//        Fetch candleSticks if needed
        if candleSticks.isEmpty {
            dispatchGroup.enter()
            
            APIManager.shared.candles(for: symbol) { [weak self] result in
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let stockCandles):
                    self?.candleSticks = stockCandles.candleSticks
                case .failure(let error):
                    print("Failed to fetch candles: \(error)")
                }
            }
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
    
    /// Renders the chart and collectionview for metrics for a certain stock
    private func renderChart() {
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
            chartViewModel: .init(
                data: candleSticks.map { $0.close },
                showLegend: true,
                showAxis: true,
                fillColor: getChange(from: candleSticks) < 0 ? .systemRed : .systemGreen
            ),
            metricViewModels: metricViewModels
        )
        
        tableView.tableHeaderView = headerView
    }
    
    /// Fetches the news for a certain stock asynchronously
    private func fetchNews() {
//        Fetch news
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
    
    /// Gets the change value for the last candlestick since the prior candlestick.
    /// - Parameter candleSticks: Candlestick data to parse. Array of ``CandleStick``
    /// - Returns: Double for change value
    private func getChange(from candleSticks: [CandleStick]) -> Double {
        guard let latestClose = candleSticks.last?.close,
              let priorClose = candleSticks.dropLast().last?.close
        else { return 0.0 }
        
        let change = latestClose - priorClose
        return change
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
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
        let alert = UIAlertController(title: "Added to Watchlist", message: "We've added \(companyName) (\(symbol)) to your Watchlist.", preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
}
