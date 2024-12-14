//
//  CatViewModel.swift
//  CatImageFactApp
//
//  Created by Mayur Chaudhary on 13/12/24.
//

import Foundation

// MARK: - ViewModel
class CatViewModel {
    private let apiService: APIServiceProtocol
    @Published var catFact: String? = nil
    @Published var catImageURL: String? = nil
    @Published var isLoading: Bool = false
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchCatData() {
        isLoading = true
        fetchCatFact()
        fetchCatImage()
    }
    
    // Method to fetch Fact from Api
    private func fetchCatFact() {
        apiService.getCatFact { [weak self] result in
            switch result {
            case .success(let factResponse):
                self?.catFact = factResponse.data.first
            case .failure:
                self?.catFact = "Failed to load fact"
            }
            self?.checkLoadingState()
        }
    }
    
    // Method to fetch Cat Image from API
    private func fetchCatImage() {
        apiService.getCatImage { [weak self] result in
            switch result {
            case .success(let image):
                self?.catImageURL = image.url
            case .failure:
                self?.catImageURL = nil
            }
            self?.checkLoadingState()
        }
    }
    
    // Method to check Loading state
    private func checkLoadingState() {
        if catFact != nil && catImageURL != nil {
            isLoading = false
        }
    }
}
