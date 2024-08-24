//
//  File.swift
//  
//
//  Created by Mohammaad Azri Khairuddin on 25/08/24.
//

import UIKit

public extension UIImageView {
    
    func loadFromUrl(
        urlString: String,
        completion: @escaping (UIImage) -> Void
    ) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
}
