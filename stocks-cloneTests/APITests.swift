//
//  APITests.swift
//  APITests
//
//  Created by Nozhan Amiri on 6/19/22.
//

@testable import stocks_clone
import XCTest

class APITests: XCTestCase {
    
    /// Tests whether `APIManager.search(query:)` is behaving as expected.
    func testSearch() throws {
        let symbol = "AAPL"
        
        APIManager.shared.search(query: symbol) { result in
            switch result {
                
            case .success(let response):
//                Assert we have data
                XCTAssertNotNil(response.result, "Search results should not be nil")
                XCTAssertGreaterThan(response.count, 0, "Search response count should be greater than zero")
                
//                Assert we have symbol in results
                let searchResults = response.result
                XCTAssertTrue(
                    searchResults.contains { $0.displaySymbol == symbol },
                    "Search results don't contain symbol"
                )
                
            case .failure(let error):
                print("Error: \(error)")
                XCTFail("Failed to fetch search response")
            }
        }
        
    }
    
    /// Tests whether `APIManager.news(for:)` is behaving as expected.
    func testMarketNews() throws {
        APIManager.shared.news(for: .topStories) { result in
            switch result {
            case .success(let stories):
//                Assert we have news data
                XCTAssertNotNil(stories, "Stories should not be nil")
                XCTAssertGreaterThan(stories.count, 0, "Stories count should be greater than zero")
                
//                Assert category is "general"
                XCTAssertEqual(stories[0].category, "general", "Stories category should be general")
                
//                Assert stories have valid image URL
                for story in stories {
                    XCTAssertNotNil(URL(string: story.image), "Story image should contain valid URL")
                }
                
//                Assert stories are in reverse chronological order
                for i in 0..<stories.count-1 {
                    XCTAssertGreaterThanOrEqual(
                        stories[i].datetime,
                        stories[i+1].datetime,
                        "All stories should be sorted in reverse chronological order"
                    )
                }
                
            case .failure(let error):
                print("Error: \(error)")
                XCTFail("Failed to fetch market news")
            }
        }
    }
    
    func testCompanyNews() throws {
//        Testing news for "AAPL"
        let symbol = "AAPL"
        APIManager.shared.news(for: .companyNews(symbol: symbol)) { result in
            switch result {
            case .success(let stories):
//                Assert we have news data
                XCTAssertNotNil(stories, "Stories should not be nil")
                XCTAssertGreaterThan(stories.count, 0, "Stories count should be greater than zero")
                
//                Assert category is "company news"
                XCTAssertEqual(stories[0].category, "company news", "Stories category should be \"company news\"")
                
//                Assert stories have valid image URL
                for story in stories {
                    XCTAssertNotNil(URL(string: story.image), "Story image should be a valid URL")
                }
                
//                Assert stories are in reverse chronological order
                XCTAssertEqual(stories, stories.sorted(by: { $0.datetime >= $1.datetime }),
                               "All stories should be sorted in reverse chronological order"
                )
                
//                Assert the stories are related to the company
                for story in stories {
                    XCTAssertEqual(story.related, symbol, "All stories should be related to the company")
                }
                
            case .failure(let error):
                print("Error: \(error)")
                XCTFail("Failed to fetch company news for \(symbol)")
            }
        }
    }
    
    func testCandles() throws {
//        Testing candles for "AAPL"
        let symbol = "AAPL"
        APIManager.shared.candles(for: symbol) { result in
            switch result {
            case .success(let stockCandles):
//                Assert we have candle data
                XCTAssertNotNil(stockCandles.close, "Close values should not be nil")
                XCTAssertNotNil(stockCandles.open, "Open values should not be nil")
                XCTAssertNotNil(stockCandles.high, "High values should not be nil")
                XCTAssertNotNil(stockCandles.low, "Low values should not be nil")
                XCTAssertNotNil(stockCandles.status, "Status string should not be nil")
                XCTAssertNotNil(stockCandles.timestamp, "Timestamp values should not be nil")
                XCTAssertNotNil(stockCandles.volume, "Volume values should not be nil")
                
//                Assert computed properties are working
                XCTAssertNotNil(stockCandles.candleSticks, "Computed property \"candleSticks\" should not be nil")
                XCTAssertEqual(stockCandles.candleSticks, stockCandles.candleSticks.sorted(by: { $0.date < $1.date }),
                               "Candlesticks should be sorted in chronological order"
                )
                XCTAssertEqual(stockCandles.totalVolume, stockCandles.volume.reduce(0, +),
                               "Total volume should equal sum of all volumes"
                )
                
//                Assert low and high don't exceed boundaries (e.g. candles are valid)
                for stick in stockCandles.candleSticks {
                    XCTAssertGreaterThanOrEqual(stick.high, stick.open, "High should be greater than or equal to Open")
                    XCTAssertGreaterThanOrEqual(stick.high, stick.close, "High should be greater than or equal to Close")
                    XCTAssertLessThanOrEqual(stick.low, stick.open, "Low should be less than or equal to Open")
                    XCTAssertLessThanOrEqual(stick.low, stick.close, "Low should be less than or equal to Close")
                }
                
//                Assert start and end dates are proper
                guard let firstDate = stockCandles.candleSticks.first?.date else {
                    XCTFail("First candlestick inexistent or does not have a date")
                    return
                }
                guard let lastDate = stockCandles.candleSticks.last?.date else {
                    XCTFail("Last candlestick inexistent or does not have a date")
                    return
                }
                XCTAssertGreaterThanOrEqual(
                    firstDate,
                    Date().addingTimeInterval(.days(-30)),
                    "First candlestick has a date prior to 30 days ago"
                )
                XCTAssertLessThanOrEqual(
                    lastDate,
                    Date(),
                    "Last candlestick has a date later than today"
                )
                
            case .failure(let error):
                print("Error: \(error)")
                XCTFail("Failed to fetch candles for \(symbol)")
            }
        }
    }
    
    func testMetrics() throws {
//        Testing metrics for "AAPL"
        let symbol = "AAPL"
        APIManager.shared.financialMetrics(for: symbol) { result in
            switch result {
            case .success(let metricsResponse):
//                Assert not nil
                XCTAssertNotNil(metricsResponse.metric, "\"metric\" property should not be nil")
                XCTAssertNotNil(metricsResponse.metric.beta, "beta should not be nil")
                XCTAssertNotNil(metricsResponse.metric.fiftyTwoWeekHigh, "fiftyTwoWeekHigh should not be nil")
                XCTAssertNotNil(metricsResponse.metric.fiftyTwoWeekHighDate, "fiftyTwoWeekHighDate should not be nil")
                XCTAssertNotNil(metricsResponse.metric.fiftyTwoWeekLow, "fiftyTwoWeekLow should not be nil")
                XCTAssertNotNil(metricsResponse.metric.fiftyTwoWeekLowDate, "fiftyTwoWeekLowDate should not be nil")
                XCTAssertNotNil(metricsResponse.metric.fiftyTwoWeekPRD, "fiftyTwoWeekPRD should not be nil")
                XCTAssertNotNil(metricsResponse.metric.tenDayAvgVolume, "tenDayAvgVolume should not be nil")
                XCTAssertNotNil(metricsResponse.metric.threeMonthsAvgVolume, "threeMonthsAvgVolume should not be nil")
                
            case .failure(let error):
                print("Error: \(error)")
                XCTFail("Failed to fetch basic financial metrics for \(symbol)")
            }
        }
    }
}
