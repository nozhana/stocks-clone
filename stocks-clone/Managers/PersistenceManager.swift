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
        
    }
    
    private init() {}
    
//    MARK: - Public
    
    public var watchlist: [String] { [] }
    
    public func addToWatchlist () {
        
    }
    
    public func removeFromWatchlist () {
        
    }
    
//    MARK: - Private
    
    private var hasOnboarded: Bool { false }
    
    
    
}
