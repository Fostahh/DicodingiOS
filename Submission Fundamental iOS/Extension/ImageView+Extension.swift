//
//  ImageView+Extension.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 22/03/23.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFromUrl(urlString: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
