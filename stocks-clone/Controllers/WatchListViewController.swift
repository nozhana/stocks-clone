//
//  WatchListViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit
import FloatingPanel

/// The view controller for the main landing page, e.g. the Watchlist.
class WatchListViewController: UIViewController {
    
    /// The floating panel that shows top stories and other data.
    private var panelVC: FloatingPanelController?
    
    /// The timer that manages the timing of API calls when the user searches for a symbol.
    private var searchTimer: Timer?
    
    /// The maximum width for the right-aligned content in the watchlist TableViewCells.
    ///
    /// Handled in ``WatchlistTableViewCell``
    static var maxCellRightContentWidth: CGFloat = 0
    
    /// A dictionary that maps symbols to their approppriate candlestick data.
    private var watchlistMap: [String: [CandleStick]] = [:]
    
    /// WatchlistTableViewCell Viewmodels for configuration
    private var viewModels: [WatchlistTableViewCell.ViewModel] = []
    
    /// The `UITableView` that contains the watchlist data
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchlistTableViewCell.self,
                           forCellReuseIdentifier: WatchlistTableViewCell.identifier)
        return tableView
    }()

//    MARK: - Lifecycle
    
    /// Called when the view finished loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTitle()
        setupSearchController()
        setupTableView()
        fetchWatchlistData()
        setupObserver()
        setupFloatingPanel()
    }
    
    /// Called when the view finished laying out subviews. Sets the tableView's frame to the view's bounds.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
//    MARK: - Private
    
    /// Sets up the page title
    private func setupTitle() {
        title = "Stocks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Sets up the search controller and the search results controller
    private func setupSearchController() {
        let resultsVC = SearchResultsViewController()
        resultsVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultsVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    /// Sets up the watchlist table view
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Fetches the candlestick data for watchlist symbols if needed, and then creates WatchlistTableViewCell viewmodels.
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlistSymbols
        
        let dispatchGroup = DispatchGroup()
        
        for symbol in symbols where watchlistMap[symbol] == nil {
            dispatchGroup.enter()
            
            APIManager.shared.candles(for: symbol) { [weak self] result in
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let candles):
                    let candleSticks = candles.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }
    
    /// Called in ``fetchWatchlistData()``. Creates WatchlistTableViewCell viewmodels using candlestick data in ``watchlistMap``
    private func createViewModels() {
        var viewModels: [WatchlistTableViewCell.ViewModel] = []
        
        for (symbol, candleSticks) in watchlistMap {
            viewModels.append(
                .init(
                    symbol: symbol,
                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "No name available",
                    price: .decimalFormatted(from: candleSticks.last?.close ?? 0.0),
                    changePercentage: .changePercentFormatted(from: getChangeFraction(from: candleSticks)),
                    changeColor: getChange(from: candleSticks) < 0 ? .systemRed : .systemGreen,
                    change: .changeFormatted(from: getChange(from: candleSticks)),
                    chartViewModel: .init(
                        data: candleSticks.map { $0.close },
                        showLegend: false,
                        showAxis: false,
                        fillColor: getChange(from: candleSticks) < 0 ? .systemRed : .systemGreen
                    )
                )
            )
//            #DEBUG: Check if correct data is fetched
            let lastVM = viewModels.last!
            print("""

                Symbol: \(lastVM.symbol)
                Current price: \(lastVM.price)
                Change: \(lastVM.change)
                Percent changed: \(lastVM.changePercentage)
                Change color: \(lastVM.changeColor)
            """)
        }
        
        self.viewModels = viewModels
    }
    
    /// Gets the change value from previous candle for last candle
    /// - Parameter candleSticks: Array of ``CandleStick`` data
    /// - Returns: Double for change value
    private func getChange(from candleSticks: [CandleStick]) -> Double {
        guard let latestClose = candleSticks.last?.close,
              let priorClose = candleSticks.dropLast().last?.close
        else { return 0.0 }
        
        let change = latestClose - priorClose
        return change
    }
    
    /// Gets the fraction of changed value from previous candle for last candle
    /// - Parameter candleSticks: Array of ``CandleStick`` data
    /// - Returns: Double for fraction of change
    private func getChangeFraction(from candleSticks: [CandleStick]) -> Double {
        guard let latestClose = candleSticks.last?.close,
              let priorClose = candleSticks.dropLast().last?.close
        else { return 0.0 }
        
        let changeFraction = (latestClose - priorClose) / priorClose
        return changeFraction
    }
    
    /// Sets up the floating panel and the ``NewsViewController``
    private func setupFloatingPanel() {
        let newsVC = NewsViewController(type: .topStories)
        panelVC = FloatingPanelController(delegate: self)
        panelVC?.surfaceView.backgroundColor = .secondarySystemBackground
        panelVC?.set(contentViewController: newsVC)
        panelVC?.track(scrollView: newsVC.tableView)
        panelVC?.addPanel(toParent: self)
    }
    
    /// Sets up a notification observer for `.didAddToWatchlist`.
    ///
    /// The action comprises of removing all cell viewmodels and fetching the watchlist data again.
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            forName: .didAddToWatchlist,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.viewModels.removeAll()
                self?.fetchWatchlistData()
        }
    }
    
}

// MARK: - Extensions

extension WatchListViewController: UISearchResultsUpdating {
    /// Updates search results when the user starts typing
    /// - Parameter searchController: searchController to update
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
    /// Called when the user selects a row in search results. Presents a ``StockDetailsViewController``
    /// - Parameter result: The selected result
    func searchResultsViewControllerDidSelect(result: SearchResult) {
//        Hide keyboard after selection
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        HapticsManager.shared.vibrateForSelection()
        
        let detailVC = StockDetailsViewController(
            symbol: result.displaySymbol,
            companyName: result.description
        )
        detailVC.title = result.description
        
        let navVC = UINavigationController(rootViewController: detailVC)
        present(navVC, animated: true)
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        WatchlistTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WatchlistTableViewCell.identifier,
            for: indexPath
        ) as? WatchlistTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
//    Editing cells
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HapticsManager.shared.vibrateForImpact(for: .light)
            
            tableView.beginUpdates()
            
//            Update persistence
            PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)
            
//            Update viewModels
            viewModels.remove(at: indexPath.row)
            
//            Delete row
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
    }
    
//    Selecting cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let viewModel = viewModels[indexPath.row]
        let detailVC = StockDetailsViewController(
            symbol: viewModel.symbol,
            companyName: viewModel.companyName,
            candleSticks: watchlistMap[viewModel.symbol] ?? []
        )
        detailVC.title = viewModel.companyName
        
        let navVC = UINavigationController(rootViewController: detailVC)
        present(navVC, animated: true)
    }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        navigationController?.setNavigationBarHidden(state == .full, animated: true)
    }
}

extension WatchListViewController: WatchlistTableViewCellDelegate {
    func didSetMaxCellRightContentWidth() {
//        TODO: Optimize - Only refresh rows prior to the row changing the max width e.g. current row
        tableView.reloadData()
    }
}
