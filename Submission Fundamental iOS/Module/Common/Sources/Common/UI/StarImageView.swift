//
//  StarImageView.swift
//
//
//  Created by Mohammaad Azri Khairuddin on 25/08/24.
//

import UIKit

public func makeStarImageView(rating: Double) -> UIImageView {
    let fullStar = UIImage(systemName: "star")
    let fullStarFilled = UIImage(systemName: "star.fill")
    let halfStarFilled = UIImage(systemName: "star.leadinghalf.filled")
    
    var uiImageView = UIImageView(image: fullStar)
    uiImageView.contentMode = .scaleAspectFit
    
    switch true {
    case rating >= 1:
        uiImageView = UIImageView(image: fullStarFilled)
    case rating < 1 && rating > 0:
        uiImageView = UIImageView(image: halfStarFilled)
    default:
        break
    }
    
    return uiImageView
}
