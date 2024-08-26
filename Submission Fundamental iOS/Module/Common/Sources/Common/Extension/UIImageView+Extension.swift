//
//  File.swift
//  
//
//  Created by Mohammaad Azri Khairuddin on 25/08/24.
//

import UIKit

private let imageCache = NSCache<NSString, AnyObject>()

public extension UIImageView {
    
    func loadImageFromUrl(
        urlString: String,
        completion: @escaping (UIImage) -> Void
    ) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            completion(cachedImage)
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    completion(downloadedImage)
                }
            })
            
        }).resume()
    }
    
}
