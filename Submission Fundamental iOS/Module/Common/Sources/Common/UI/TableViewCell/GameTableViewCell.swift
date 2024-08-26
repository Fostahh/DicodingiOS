//
//  GameTableViewCell.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 09/01/23.
//

import UIKit

public class GameTableViewCell: UITableViewCell {
    
    // MARK: - View Param
    public struct ViewParam {
        let rating: Double
        let backgroundImage, name, released: String
        
        public init(rating: Double, backgroundImage: String, name: String, released: String) {
            self.rating = rating
            self.backgroundImage = backgroundImage
            self.name = name
            self.released = released
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var gameReleaseLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!
    
    // MARK: - Private Properties
    private var gameRating = 0.0
    
    // MARK: Public Methods
    public func configureView(viewParam: GameTableViewCell.ViewParam) {
        gameRating = round(viewParam.rating * 10) / 10.0
        loadImage(urlString: viewParam.backgroundImage)
        gameTitleLabel.text = viewParam.name
        gameReleaseLabel.text = viewParam.released
        setRatingView()
    }
    
    // MARK: Private Methods
    private func loadImage(urlString: String) {
        gameImageView.loadImageFromUrl(urlString: urlString) { [weak self] image in
            self?.gameImageView.image = image
        }
    }
    
    private func setRatingView() {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 1...5 {
            let starView = makeStarImageView(rating: gameRating)
            ratingStackView.addArrangedSubview(starView)
            gameRating -= 1
        }
    }
    
}
