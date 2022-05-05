//
//  SearchResponse.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/5/22.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
