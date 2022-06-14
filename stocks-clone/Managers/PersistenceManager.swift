//
//  PersistenceManager.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/1/22.
//

import Foundation

/// An object that manages *Persistence* within the app – e.g. objects that remain in memory after the app is closed.
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
    
    /// The default implementation of this initializer does nothing.
    private init() {}
    
//    MARK: - Public
    
    /// An array of strings that holds the symbols in the watchlist. Gets the symbols from UserDefaults.
    ///
    /// This computed property also sets a default list of symbols for the watchlist if the user hasn't onboarded yet.
    public var watchlistSymbols: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.hasOnBoardedKey)
            setupDefaultWatchlist()
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    /// Tells whether the watchlist contains a symbol or not.
    /// - Parameter symbol: Symbol to look for in the watchlist
    /// - Returns: `true` if the symbol is in the watchlist and `false` if not.
    public func watchlistContains(symbol: String) -> Bool {
        watchlistSymbols.contains(symbol)
    }
    
    /// Adds a given symbol with description to the watchlist.
    /// - Parameters:
    ///   - symbol: symbol to add
    ///   - companyName: Name of the company – e.g. description of the symbol
    public func addToWatchlist(symbol: String, companyName: String) {
        var symbols: [String] = watchlistSymbols
        
        symbols.append(symbol)
        
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }
    
    /// Removes a given symbol from the watchlist.
    /// - Parameter symbol: Symbol to remove
    public func removeFromWatchlist(symbol: String) {
        var symbols: [String] = watchlistSymbols
        
        symbols.removeAll { item in
            item == symbol
        }
        
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        userDefaults.set(nil, forKey: symbol)
    }
    
//    MARK: - Private
    
    /// `true` if the user has onboarded the app
    private var hasOnboarded: Bool {
        userDefaults.bool(forKey: Constants.hasOnBoardedKey)
    }
    
    /// Sets up the default watchlist. Called when the user hasn't onboarded the app yet.
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
