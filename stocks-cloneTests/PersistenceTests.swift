//
//  PersistenceTests.swift
//  stocks-cloneTests
//
//  Created by Nozhan Amiri on 7/5/22.
//

@testable import stocks_clone
import XCTest

class PersistenceTests: XCTestCase {
    let userDefaults: UserDefaults = .standard

    override func setUpWithError() throws {
        userDefaults.set(false, forKey: "hasOnBoarded")
    }

    func testDefaultWatchlist() throws {
        let watchlist = PersistenceManager.shared.watchlistSymbols
        
//        Assert watchlist not nil
        XCTAssertNotNil(watchlist, "Watchlist should not be nil")
        
//        Assert AAPL in watchlist
        XCTAssertTrue(
            watchlist.contains("AAPL"),
            "AAPL not in default watchlist"
        )
        
//        Assert AAPL description is equal to "Apple Inc."
        XCTAssertEqual(
            userDefaults.string(forKey: "AAPL"),
            "Apple Inc.",
            "AAPL description does not equal \"Apple Inc.\""
        )
        
//        Assert computed property watchlistSymbols gets userdefaults back properly
        XCTAssertEqual(
            userDefaults.stringArray(forKey: "watchlist"),
            watchlist,
            "Watchlist not written to UserDefaults properly"
        )
        
//        Assert all symbols have a description
        for symbol in watchlist {
            XCTAssertNotNil(
                userDefaults.string(forKey: symbol),
                "No description for \(symbol) in UserDefaults"
            )
        }
    }
    
    func testAddToWatchlist() throws {
        let symbol = "JNJ"
        let companyName = "Johnson and Johnson"
        
//        Adding symbol
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
        
//        Check whether symbol exists in watchlist
        XCTAssertTrue(
            PersistenceManager.shared.watchlistContains(symbol: symbol),
            "\(symbol) should be in watchlist"
        )
        
//        Check whether symbol is stored in UserDefaults watchlist
        if let udWatchlist = userDefaults.stringArray(forKey: "watchlist") {
            XCTAssertTrue(udWatchlist.contains(symbol), "\(symbol) should be in UserDefaults watchlist")
        } else {
            XCTFail("Failed to retrieve watchlist from UserDefaults")
        }
        
//        Check whether company name exists for symbol in UserDefaults
        if let udCompanyName = userDefaults.string(forKey: "JNJ") {
            XCTAssertEqual(
                udCompanyName, companyName,
                "Company name for \(symbol) should equal \"\(companyName)\" but is \"\(udCompanyName)\""
            )
        } else {
            XCTFail("Company name for \(symbol) should exist in UserDefaults as \(companyName)")
        }
    }
    
    func testRemoveFromWatchlist() throws {
        let symbolToRemove = "GOOG"
        
//        Removing symbol
        PersistenceManager.shared.removeFromWatchlist(symbol: symbolToRemove)
        
//        Check whether symbol exists in watchlist
        XCTAssertFalse(
            PersistenceManager.shared.watchlistContains(symbol: symbolToRemove),
            "\(symbolToRemove) should not exist in watchlist"
        )
        
//        Check whether symbol exists in Userdefaults watchlist
        XCTAssertFalse(
            userDefaults.stringArray(forKey: "watchlist")!.contains(symbolToRemove),
            "\(symbolToRemove) should not exist in UserDefaults watchlist"
        )
        
//        Check whether company name exists for symbol in UserDefaults
        XCTAssertNil(
            userDefaults.string(forKey: symbolToRemove),
            "\(symbolToRemove) should not exist in UserDefaults"
        )
    }
}
