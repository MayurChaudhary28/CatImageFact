//
//  CatModel.swift
//  CatImageFactApp
//
//  Created by Mayur Chaudhary on 13/12/24.
//

import Foundation

// MARK: - Model
struct CatFactResponse: Decodable {
    let data: [String]
}

struct CatImage: Decodable {
    let url: String
}
