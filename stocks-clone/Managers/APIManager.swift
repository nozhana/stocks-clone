//
//  APIManager.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/1/22.
//

import Foundation

/// An object that manages and calls the API on the app's behalf.
///
/// **Properties**
/// - ``shared`` is instance of ``APIManager``
final class APIManager {
//    MARK: - Properties
    
    /// Singleton instance of the class
    static let shared = APIManager()
    
    /// Holds `apiKey`, `sandboxApiKey`, `baseURL`
    private struct Constants {
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseURL = ""
    }
    
    private init () {}
    
//    MARK: - Public
    
//    Get stock info
    
//    Search stocks
    
//    MARK: - Private
    
    /// Enumerates various endpoints of the API URL.
    ///
    /// Extends `String` type.
    ///
    /// **Cases**
    /// - `search`
    private enum Endpoint: String {
        case search
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
    /// - Returns: `URL` Optional type
    private func url (
        for endpoint: Endpoint,
        queryParams: [String: String] = [:]
    ) -> URL? {
//        TODO: Generate url for endpoints
        
        return nil
    }
    
    /// Perform a URL request given the parameters below.
    ///
    /// Returns nothing.
    /// - Parameters:
    ///   - url: A `URL` optional for request
    ///   - expecting: Will hold expected value after decoded by `JSONDecoder().decode`
    ///   - completion: Closure that takes `Result` of `.success` or `.failure`
    ///   with appropriately decoded result or an error as parameter. Returns nothing
    private func request<T: Codable> (
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
//        MARK: Check URL
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
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
