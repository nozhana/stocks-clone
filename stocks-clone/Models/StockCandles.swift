//
//  StockCandles.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/17/22.
//

import Foundation

struct StockCandles: Codable {
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let open: [Double]
    let status: String
    let timestamp: [TimeInterval]
    let volume: [Double]
    
    enum CodingKeys: String, CodingKey {
        case close = "c"
        case high = "h"
        case low = "l"
        case open = "o"
        case status = "s"
        case timestamp = "t"
        case volume = "v"
    }
    
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
    
    var totalVolume: Double {
        volume.reduce(0, +)
    }
}

struct CandleStick {
    let date: Date
    let open: Double
    let close: Double
    let high: Double
    let low: Double
}
