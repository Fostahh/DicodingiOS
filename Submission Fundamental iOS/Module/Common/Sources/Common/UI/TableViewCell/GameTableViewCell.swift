//
//  GameTableViewCell.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 09/01/23.
//

import UIKit
import Core

public class GameTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var gameReleaseLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!
    
    // MARK: - Private Properties
    private var gameRating = 0.0
    
    // MARK: - Override Methods
    public override func prepareForReuse() {
        gameImageView.image = nil
    }
    
    // MARK: Public Methods
    public func configureView(game: VideoGame) {
        gameRating = round(game.rating * 10) / 10.0
        loadImage(urlString: game.backgroundImage)
        gameTitleLabel.text = game.name
        gameReleaseLabel.text = game.released
        setRatingView(with: game)
    }
    
    // MARK: Private Methods
    private func loadImage(urlString: String) {
        gameImageView.loadFromUrl(urlString: urlString) { [weak self] image in
            self?.gameImageView.image = image
        }
    }
    
    private func setRatingView(with game: VideoGame) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 1...5 {
            let starView = makeStarImageView(rating: gameRating)
            ratingStackView.addArrangedSubview(starView)
            gameRating -= 1
        }
    }
    
}
