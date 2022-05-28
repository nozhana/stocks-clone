//
//  PersistenceManager.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/1/22.
//

import Foundation

final class PersistenceManager {
    /// Singleton of `PersistenceManager`
    static let shared = PersistenceManager()
    
    /// Shared instance of `UserDefaults`
    private let userDefaults: UserDefaults = .standard
    
    /// Struct to hold constants across `PersistenceManager`
    private struct Constants {
        static let hasOnBoardedKey = "hasOnBoarded"
        static let watchlistKey = "watchlist"
    }
    
    private init() {}
    
//    MARK: - Public
    
    public var watchlistSymbols: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.hasOnBoardedKey)
            setupDefaultWatchlist()
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    public func watchlistContains(symbol: String) -> Bool {
        watchlistSymbols.contains(symbol)
    }
    
    public func addToWatchlist(symbol: String, companyName: String) {
        var symbols: [String] = watchlistSymbols
        
        symbols.append(symbol)
        
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }
    
    public func removeFromWatchlist(symbol: String) {
        var symbols: [String] = watchlistSymbols
        
        symbols.removeAll { item in
            item == symbol
        }
        
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        userDefaults.set(nil, forKey: symbol)
    }
    
//    MARK: - Private
    
    private var hasOnboarded: Bool {
        userDefaults.bool(forKey: Constants.hasOnBoardedKey)
    }
    
    private func setupDefaultWatchlist() {
        let watchlistMap = [
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corp.",
            "GOOG": "Alphabet Inc.",
            "FB": "Facebook Inc.",
            "META": "Meta Platforms",
            "AMZN": "Amazon Inc.",
            "SNAP": "Snapchat Inc.",
            "WORK": "Slack Tech.",
            "NVDA": "NVIDIA Inc.",
            "NKE": "Nike Inc."
        ]
        
        userDefaults.set(watchlistMap.keys.map { $0 }, forKey: Constants.watchlistKey)
        for (symbol, name) in watchlistMap {
            userDefaults.set(name, forKey: symbol)
        }
    }
    
}
