//
//  UIImageView+Extensions.swift
//  CatImageFactApp
//
//  Created by Mayur Chaudhary on 13/12/24.
//

import Foundation
import UIKit

// MARK: - UIImageView Extension
extension UIImageView {
    func loadImage(from url: URL, completion: @escaping () -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
                completion()
            }
        }.resume()
    }
}
