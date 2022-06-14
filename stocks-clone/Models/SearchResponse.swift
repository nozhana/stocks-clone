//
//  SearchResponse.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/5/22.
//

import Foundation

/// A codable model representing a ``APIManager/search(query:completion:)`` API call response.
///
/// Comprises:
/// - `count: Int`
/// - `result: [` ``SearchResult`` `]`
struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

/// A codable model representing the `result` dictionary from a ``SearchResponse``.
///
/// Comprises:
/// - `description: String`
/// - `displaySymbol: String`
/// - `symbol: String`
/// - `type: String`
struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
