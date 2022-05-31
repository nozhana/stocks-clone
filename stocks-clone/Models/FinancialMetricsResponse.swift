//
//  FinancialMetricsResponse.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/31/22.
//

import Foundation

struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}

struct Metrics: Codable {
    let tenDayAvgVolume: Double
    let threeMonthsAvgVolume: Double
    let fiftyTwoWeekHigh: Double
    let fiftyTwoWeekHighDate: String
    let fiftyTwoWeekLow: Double
    let fiftyTwoWeekLowDate: String
    let fiftyTwoWeekPRD: Double
    let beta: Double
    
    enum CodingKeys: String, CodingKey {
        case tenDayAvgVolume = "10DayAverageTradingVolume"
        case threeMonthsAvgVolume = "3MonthAverageTradingVolume"
        case fiftyTwoWeekHigh = "52WeekHigh"
        case fiftyTwoWeekHighDate = "52WeekHighDate"
        case fiftyTwoWeekLow = "52WeekLow"
        case fiftyTwoWeekLowDate = "52WeekLowDate"
        case fiftyTwoWeekPRD = "52WeekPriceReturnDaily"
        case beta = "beta"
    }
}
