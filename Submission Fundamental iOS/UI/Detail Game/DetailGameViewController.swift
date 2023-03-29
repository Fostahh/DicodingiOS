//
//  DetailGameViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    public var gameId: Int = 0

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ageRestrictionLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var developersLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!
    
    private let viewModel = DetailGameViewModel(gameServicesNetworkModel: GameServicesDefaultNetworkModel())
    private var gameRating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        bindObserver()
        viewModel.retrieveGameDetail(id: gameId)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func bindObserver() {
        viewModel.loadingObservable = { [weak self] isLoading in
            self?.configureView(isLoading: isLoading)
            if isLoading {
                self?.loadingView.startAnimating()
            } else {
                self?.loadingView.stopAnimating()
            }
        }
        
        viewModel.errorObservable = { [weak self] errorMessage in
//            self?.configureView(isError: true, errorMessage: errorMessage)
        }
        
        viewModel.gameObservable = { [weak self] game in
            self?.setView(game: game)
        }
    }
    
    private func configureView(isLoading: Bool) {
        scrollView.isHidden = isLoading
        loadingView.isHidden = !isLoading
    }
    
    private func setView(game: DetailVideoGame) {
        gameRating = round(game.rating * 10) / 10.0
        
        bannerImageView.loadFromUrl(urlString: game.backgroundImageAdditional) { [weak self] image in
            self?.bannerImageView.image = image
        }
        
        backgroundImageView.loadFromUrl(urlString: game.backgroundImage) { [weak self] image in
            self?.backgroundImageView.image = image
        }
        
        for _ in 1...5 {
            let starView = makeStarImageView(rating: gameRating)
            ratingStackView.addArrangedSubview(starView)
            gameRating -= 1
        }
        
        titleLabel.text = game.name
        releaseDateLabel.text = game.released
        ageRestrictionLabel.text = game.ageRestriction
        descriptionLabel.text = game.description
        genresLabel.text = game.genresInString
        developersLabel.text = "Developers: " + game.developersInString
    }
}
