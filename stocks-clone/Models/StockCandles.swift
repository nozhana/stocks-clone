//
//  StockCandles.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/17/22.
//

import Foundation

/// A codable model representing a ``APIManager/candles(for:numberOfDays:completion:)`` API call response.
///
/// Comprises:
/// - `close: [Double]`
/// - `high: [Double]`
/// - `low: [Double]`
/// - `open: [Double]`
/// - `status: String`
/// - `timestamp: [TimeInterval]`
/// - `volume: [Double]`
struct StockCandles: Codable {
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let open: [Double]
    let status: String
    let timestamp: [TimeInterval]
    let volume: [Double]
    
    /// Coding keys for ``StockCandles``.
    enum CodingKeys: String, CodingKey {
        case close = "c"
        case high = "h"
        case low = "l"
        case open = "o"
        case status = "s"
        case timestamp = "t"
        case volume = "v"
    }
    
    /// An array of ``CandleStick`` models for all data in a ``StockCandles`` API call response.
    var candleSticks: [CandleStick] {
        var sticks: [CandleStick] = []
        
        for i in 0..<close.count {
            sticks.append(
                .init(
                    date: Date(timeIntervalSince1970: timestamp[i]),
                    open: open[i],
                    close: close[i],
                    high: high[i],
                    low: low[i]
                )
            )
        }
        
        return sticks.sorted(by: { $0.date < $1.date })
    }
    
    /// The total traded volume for the specified `TimeInterval` in this response.
    var totalVolume: Double {
        volume.reduce(0, +)
    }
}

/// A model representing a candlestick in ``StockCandles``.
///
/// Comprises:
/// - `date: Date`
/// - `open: Double`
/// - `close: Double`
/// - `high: Double`
/// - `low: Double`
struct CandleStick {
    let date: Date
    let open: Double
    let close: Double
    let high: Double
    let low: Double
}
