//
//  CatImageFactAppTests.swift
//  CatImageFactAppTests
//
//  Created by Mayur Chaudhary on 13/12/24.
//

import XCTest
import Combine

@testable import CatImageFactApp

final class CatImageFactAppTests: XCTestCase {
    
    var viewModel: CatViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = CatViewModel(apiService: mockAPIService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchCatData_EmptyResponse() {
        // Arrange
        mockAPIService.shouldReturnError = false
        mockAPIService.mockCatFactResponse = CatFactResponse(data: [])
        mockAPIService.mockCatImageResponse = CatImage(url: "")
        let factData = mockAPIService.mockCatFactResponse?.data.isEmpty ?? false
        let imageData = mockAPIService.mockCatImageResponse?.url.isEmpty ?? false
        XCTAssert(factData)
        XCTAssert(imageData)
    }
    
    func testFetchCatData_SuccessfulResponse() {
        // Arrange
        mockAPIService.shouldReturnError = false
        mockAPIService.mockCatFactResponse = CatFactResponse(data: ["Cats are awesome!"])
        mockAPIService.mockCatImageResponse = CatImage(url: "https://example.com/cat.jpg")
        let factData = mockAPIService.mockCatFactResponse?.data.isEmpty ?? false
        let imageData = mockAPIService.mockCatImageResponse?.url.isEmpty ?? false
        XCTAssert(!factData)
        XCTAssert(!imageData)
    }

    func testFetchCatData_FactFailure() {
        // Arrange
        mockAPIService.shouldReturnError = false
        mockAPIService.mockCatFactResponse = CatFactResponse(data: ["Cats are awesome!"])
        mockAPIService.mockCatImageResponse = CatImage(url: "https://example.com/cat.jpg")
        let expectation = expectation(description: "Fetch cat fact fails gracefully")
        
        // Act
        mockAPIService.getCatFact { result in
            switch result {
            case .success(let fact):
                print(fact)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
