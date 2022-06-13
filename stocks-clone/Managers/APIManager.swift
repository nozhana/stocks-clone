//
//  APIManager.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/1/22.
//

import Foundation

/// An object that manages and calls the API on the app's behalf.
///
/// *Singleton* ``shared``
final class APIManager {
//    MARK: - Properties
    
    /// Shared instance of ``APIManager``
    static let shared = APIManager()
    
    /// Holds `apiKey`, `sandboxApiKey`, `baseURL`
    private struct Constants {
        static let apiKey = "c9opsuaad3idb416ln9g"
        static let sandboxApiKey = "sandbox_c9opsuaad3idb416lna0"
        static let baseURL = "https://finnhub.io/api/v1/"
    }
    
    /// The default implementation of this initializer does nothing.
    private init () {}
    
//    MARK: - Public
    
    /// Makes a request to `stockCandles` endpoint for a specific symbol.
    /// The API endpoint is `stock/candles`
    /// - Parameters:
    ///   - symbol: A stock symbol `String`. *i.e. –* **AAPL**
    ///   - numberOfDays: Number of days to get candles from until today as `Double`. Defaults to 7.
    ///   - completion: Closure of `Result` that holds ``StockCandles`` upon success and `Error` upon failure.
    ///
    /// Returns nothing.
    public func candles(
        for symbol: String,
        numberOfDays: Double = 30,
        completion: @escaping (Result<StockCandles, Error>) -> Void
    ) {
        let to = Date()
        let from = to.addingTimeInterval(.days(-numberOfDays))
        
        request(
            url: url(
                for: .stockCandles,
                queryParams: [
                    "symbol": symbol,
                    "resolution": "D",
                    "from": "\(Int(from.timeIntervalSince1970))",
                    "to": "\(Int(to.timeIntervalSince1970))"
                ]
            ),
            expecting: StockCandles.self,
            completion: completion
        )
    }
    
    /// Makes a request to `search` endpoint for a given query.
    /// - Parameters:
    ///   - query: Given query that could comprise of a `symbol` or `displaySymbol`.
    ///   - completion: Closure of `Result` that holds ``SearchResponse`` upon success and `Error` upon failure.
    ///
    ///   Returns nothing.
    public func search(
        query: String,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ) {
        request(
            url: url(
                for: .search,
                queryParams: ["q": query]
            ),
            expecting: SearchResponse.self,
            completion: completion
        )
    }
    
    /// Makes a request to the `marketNews` or `companyNews` endpoint given the ``NewsViewController/contentType``.
    /// - Parameters:
    ///   - type: Could be ``NewsViewController/contentType/topStories`` or ``NewsViewController/contentType/companyNews(symbol:)``.
    ///   - completion: Closure of `Result` that holds an array of ``NewsStory`` upon success and `Error` upon failure.
    ///
    /// Returns nothing.
    /// - Note: ``NewsViewController/contentType/topStories`` API endpoint is `news`
    /// - Note: ``NewsViewController/contentType/companyNews(symbol:)`` API endpoint is `company-news`
    public func news(
        for type: NewsViewController.contentType,
        completion: @escaping (Result<[NewsStory], Error>) -> Void
    ) {
        switch type {
        case .topStories:
            request(
                url: url(
                    for: .marketNews,
                    queryParams: ["category": "general"]
                ),
                expecting: [NewsStory].self,
                completion: completion
            )
        case .companyNews(let symbol):
            let today = Date()
            let oneWeekAgo = today.addingTimeInterval(.days(-7))

            request(
                url: url(
                    for: .companyNews,
                    queryParams: [
                        "symbol": symbol,
                        "from": .iso8601DateString(from: oneWeekAgo),
                        "to": .iso8601DateString(from: today)
                    ]
                ),
                expecting: [NewsStory].self,
                completion: completion
            )
        }
    }
    
    public func financialMetrics(
        for symbol: String,
        completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void
    ) {
        request(
            url: url(
                for: .basicFinancials,
                queryParams: [
                    "symbol": symbol,
                    "metric": "all"
                ]
            ),
            expecting: FinancialMetricsResponse.self,
            completion: completion
        )
    }
    
//    MARK: - Private
    
    /// Enumerates various endpoints of the API URL.
    ///
    /// Extends `String` type.
    ///
    /// **Cases**
    ///  - `search`
    ///  - `marketNews`
    ///  - `companyNews`
    ///  - `stockCandles`
    private enum Endpoint: String {
        case search
        case marketNews = "news"
        case companyNews = "company-news"
        case stockCandles = "stock/candle"
        case basicFinancials = "stock/metric"
    }
    
    /// Various Errors in API
    ///
    /// **Cases**
    /// - `.invalidURL`
    /// - `.noDataReturned`
    private enum APIError: Error {
        case invalidURL, noDataReturned
    }
    
    /// Generates URL for endpoints
    ///
    /// - Warning: Unpack when calling
    /// - Parameters:
    ///   - endpoint: An endpoint to unpack of type `Endpoint` enum
    ///   - queryParams: Defaults to empty dictionary
    /// - Returns: `URL` Optional
    private func url(
        for endpoint: Endpoint,
        queryParams: [String: String] = [:]
    ) -> URL? {
        var urlString = Constants.baseURL + endpoint.rawValue
        
        var queryItems: [URLQueryItem] = []
        
        for (name, value) in queryParams {
            guard let safeValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
            queryItems.append(.init(name: name, value: safeValue))
        }
        
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        let queryString = queryItems.map { item in
            "\(item.name)=\(item.value ?? "")"
        }.joined(separator: "&")
        
        urlString += "?" + queryString
        
        return URL(string: urlString)
    }
    
    /// Perform a URL request given the parameters below.
    ///
    /// Returns nothing.
    /// - Parameters:
    ///   - url: A `URL` optional for request
    ///   - expecting: Will hold expected value after decoded by `JSONDecoder().decode`
    ///   - completion: Closure that takes `Result` of `.success` or `.failure`
    ///   with appropriately decoded result or an error as parameter. Returns nothing
    private func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
//        MARK: Check URL
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
//        Print Called URL
        print(url.absoluteURL)
        
//        MARK: Create task
//        Create a task with data and responded error. We don't care about the response.
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            Check if data exists and there's no error, otherwise pass the error to completion as failure.
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
//            Decode the data from expecting value. If successful, pass the result to completion
//            with success, otherwise, pass the error with failure.
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.noDataReturned))
            }
        }
        
        task.resume()
    }
}
