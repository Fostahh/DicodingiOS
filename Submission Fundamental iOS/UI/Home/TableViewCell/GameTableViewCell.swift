//
//  GameTableViewCell.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 09/01/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    // MARK: Public Properties
    static let identifier = "GameTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: "GameTableViewCell", bundle: nil)
    }

    // MARK: Private Properties
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var gameReleaseLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!

    private var gameRating = 0.0
    
    // MARK: Public Methods
    func configureView(game: VideoGame) {
        gameRating = round(game.rating * 10) / 10.0
        loadImage(urlString: game.backgroundImage)
        gameTitleLabel.text = game.name
        gameReleaseLabel.text = game.released
        setRatingView(with: game)
    }
    
    override func prepareForReuse() {
        gameImageView.image = nil
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
