//
//  NewsStory.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/10/22.
//

import Foundation

/// A codable model representing a ``APIManager/news(for:completion:)`` API call response.
///
/// Comprises:
/// - `category: String`
/// - `datetime: TimeInterval` (UNIX time)
/// - `headline: String`
/// - `id: Int`
/// - `image: String` (URL string)
/// - `related: String`
/// - `source: String`
/// - `summary: String`
/// - `url: String`
struct NewsStory: Codable, Equatable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let id: Int
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String

}
