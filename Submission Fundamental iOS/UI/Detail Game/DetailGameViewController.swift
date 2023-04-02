//
//  DetailGameViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    public var gameId: Int = 0
    public var isFromFavoriteScreen = false

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
    @IBOutlet weak var errorLabel: UILabel!
    
    private let viewModel = DetailGameViewModel(gameServicesNetworkModel: GameServicesDefaultNetworkModel())
    private var gameRating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        bindObserver()
        viewModel.viewDidLoad(id: gameId, isFromFavoriteScreen: isFromFavoriteScreen)
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
            self?.configureView(isError: true, errorMessage: errorMessage)
        }
        
        viewModel.gameObservable = { [weak self] game in
            self?.setView(game: game)
        }
        
        viewModel.isFavoriteObservable = { [weak self] isFavorite in
            self?.configureNavBarItem(isFavorite: isFavorite)
        }
        
        viewModel.isDeleteObservable = { [weak self] isDelete in
            self?.showAlert(isDelete: isDelete)
        }
    }
    
    private func configureNavBarItem(isFavorite: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: isFavorite ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(onFavoriteIconTapped)
        )
    }
    
    @objc private func onFavoriteIconTapped() {
        viewModel.updateVideoGameFavoriteStatus()
    }
    
    private func configureView(isLoading: Bool = false, isError: Bool = false, errorMessage: String = "") {
        if isLoading {
            loadingView.isHidden = false
            scrollView.isHidden = true
            errorLabel.isHidden = true
            errorLabel.text = nil
        } else {
            loadingView.isHidden = true
            scrollView.isHidden = isError
            errorLabel.isHidden = !isError
            errorLabel.text = errorMessage
        }
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
    
    private func showAlert(isDelete: Bool) {
        let alert = UIAlertController(
            title: "Success",
            message: isDelete ? "Video Game Unfavorited." : "Video Game Favorited.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
