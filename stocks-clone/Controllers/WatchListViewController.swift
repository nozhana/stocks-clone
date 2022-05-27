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
    
    static var maxCellRightContentWidth: CGFloat = 0
    
    private var watchlistMap: [String: [CandleStick]] = [:]
    
    private var viewModels: [WatchlistTableViewCell.ViewModel] = []
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchlistTableViewCell.self,
                           forCellReuseIdentifier: WatchlistTableViewCell.identifier)
        return tableView
    }()

//    MARK: - Lifecycle
    
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
    
    private func createViewModels() {
        var viewModels: [WatchlistTableViewCell.ViewModel] = []
        
        for (symbol, candleSticks) in watchlistMap {
            viewModels.append(
                .init(
                    symbol: symbol,
                    company: UserDefaults.standard.string(forKey: symbol) ?? "No name available",
                    price: .decimalFormatted(from: candleSticks.last?.close ?? 0.0),
                    changePercentage: .changePercentFormatted(from: getChangeFraction(from: candleSticks)),
                    changeColor: getChange(from: candleSticks) < 0 ? .systemRed : .systemGreen,
                    change: .changeFormatted(from: getChange(from: candleSticks)),
                    chartViewModel: .init(
                        data: candleSticks,
                        showLegend: false,
                        showAxis: false
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
    
    private func getChange(from candleSticks: [CandleStick]) -> Double {
        guard let latestClose = candleSticks.last?.close,
              let priorClose = candleSticks.dropLast().last?.close
        else { return 0.0 }
        
        let change = latestClose - priorClose
        return change
    }
    
    private func getChangeFraction(from candleSticks: [CandleStick]) -> Double {
        guard let latestClose = candleSticks.last?.close,
              let priorClose = candleSticks.dropLast().last?.close
        else { return 0.0 }
        
        let changeFraction = (latestClose - priorClose) / priorClose
        return changeFraction
    }
    
    private func setupFloatingPanel() {
        let newsVC = NewsViewController(type: .topStories)
        panelVC = FloatingPanelController(delegate: self)
        panelVC?.surfaceView.backgroundColor = .secondarySystemBackground
        panelVC?.set(contentViewController: newsVC)
        panelVC?.track(scrollView: newsVC.tableView)
        panelVC?.addPanel(toParent: self)
    }
    
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
//        TODO: Open details for selection
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
