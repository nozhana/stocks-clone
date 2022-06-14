//
//  FinancialMetricsResponse.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/31/22.
//

import Foundation

/// A codable model that represents a ``APIManager/financialMetrics(for:completion:)`` API call response.
///
/// Comprises:
/// - `metric: Metrics`
struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}

/// A codable model that represents `metric` in ``FinancialMetricsResponse``.
///
/// Comprises:
/// - `tenDayAvgVolume: Double`
/// - `threeMonthsAvgVolume: Double`
/// - `fiftyTwoWeekHigh: Double`
/// - `fiftyTwoWeekHighDate: String` (ISO8601)
/// - `fiftyTwoWeekLow: Double`
/// - `fiftyTwoWeekLowDate: String` (ISO8601)
/// - `fiftyTwoWeekPRD: Double`
/// - `beta: Double`
struct Metrics: Codable {
    let tenDayAvgVolume: Double
    let threeMonthsAvgVolume: Double
    let fiftyTwoWeekHigh: Double
    let fiftyTwoWeekHighDate: String
    let fiftyTwoWeekLow: Double
    let fiftyTwoWeekLowDate: String
    let fiftyTwoWeekPRD: Double
    let beta: Double
    
    /// Coding keys for ``Metrics`` in ``FinancialMetricsResponse``.
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
