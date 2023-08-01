//
//  DetailGameViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import UIKit
import Combine

class DetailGameViewController: UIViewController {

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
    
    private let viewModel: DetailGameViewModel
    private let gameId: Int
    private let isFromFavoriteScreen: Bool

    private var gameRating = 0.0
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        viewModel: DetailGameViewModel,
        gameId: Int,
        isFromFavoriteScreen: Bool = false
    ) {
        self.viewModel = viewModel
        self.gameId = gameId
        self.isFromFavoriteScreen = isFromFavoriteScreen
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.loadingObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.configureView(isLoading: isLoading)
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            })
            .store(in: &cancellables)

        viewModel.errorObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.configureView(isError: true, errorMessage: errorMessage)
            })
            .store(in: &cancellables)

        viewModel.gameObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] game in
                self?.setView(game: game)
            })
            .store(in: &cancellables)
        
        viewModel.isFavoriteObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isFavorite in
                self?.configureNavBarItem(isFavorite: isFavorite)
            })
            .store(in: &cancellables)

        viewModel.showAlertObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (_, message) in
                self?.showAlert(message: message)
            })
            .store(in: &cancellables)
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
