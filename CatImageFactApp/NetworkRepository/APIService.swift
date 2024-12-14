//
//  APIService.swift
//  CatImageFactApp
//
//  Created by Mayur Chaudhary on 13/12/24.
//

import Foundation

// MARK: - Protocol
protocol APIServiceProtocol {
    func getCatFact(completion: @escaping (Result<CatFactResponse, Error>) -> Void)
    func getCatImage(completion: @escaping (Result<CatImage, Error>) -> Void)
}

// MARK: - API Service
class APIService: APIServiceProtocol {
    
    func getCatFact(completion: @escaping (Result<CatFactResponse, Error>) -> Void) {
        let url = URL(string: APIConstants.catFactURL)!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            do {
                let factResponse = try JSONDecoder().decode(CatFactResponse.self, from: data)
                completion(.success(factResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getCatImage(completion: @escaping (Result<CatImage, Error>) -> Void) {
        let url = URL(string: APIConstants.catImageURL)!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            do {
                let images = try JSONDecoder().decode([CatImage].self, from: data)
                if let firstImage = images.first {
                    completion(.success(firstImage))
                } else {
                    completion(.failure(NSError(domain: "NoImageError", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
