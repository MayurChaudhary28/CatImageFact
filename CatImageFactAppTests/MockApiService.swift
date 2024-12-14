//
//  MockApiService.swift
//  CatImageFactAppTests
//
//  Created by Mayur Chaudhary on 14/12/24.
//

import Foundation
@testable import CatImageFactApp

// Mock API Service
class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var mockCatFactResponse: CatFactResponse?
    var mockCatImageResponse: CatImage?
    
    func getCatFact(completion: @escaping (Result<CatFactResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: nil)))
        } else if let response = mockCatFactResponse {
            completion(.success(response))
        }
    }
    
    func getCatImage(completion: @escaping (Result<CatImage, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockError", code: 2, userInfo: nil)))
        } else if let response = mockCatImageResponse {
            completion(.success(response))
        }
    }
}
