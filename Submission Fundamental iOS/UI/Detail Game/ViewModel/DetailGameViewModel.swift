//
//  DetailGameViewModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import Foundation

class DetailGameViewModel {
    
    // MARK: Public Properties
    var gameObservable: Observer<DetailVideoGame>?
    var loadingObservable: Observer<Bool>?
    var errorObservable: Observer<String>?
    
    var isFavoriteObservable: Observer<Bool>?
    var isDeleteObservable: Observer<Bool>?
    
    // MARK: Private Properties
    private let gameServicesNetworkModel: GameServicesNetworkModel
    private lazy var videoGameProvider: VideoGameProvider = { return VideoGameProvider() }()
    private var videoGame: DetailVideoGame? = nil
    private var isFavorite = false
    
    init(gameServicesNetworkModel: GameServicesNetworkModel) {
        self.gameServicesNetworkModel = gameServicesNetworkModel
    }
    
    // MARK: Public Functions
    func viewDidLoad(id: Int, isFromFavoriteScreen: Bool) {
        
        if isFromFavoriteScreen {
            retrieveGameDetailFromLocal(id: id)
        } else {
            retrieveGameDetailFromRemote(id: id)
        }
        
        checkVideoGameFavoriteStatus(id: id)
    }
    
    func updateVideoGameFavoriteStatus() {
        guard let videoGame = videoGame else {
            return
        }
        
        if isFavorite {
            videoGameProvider.deleteVideoGame(id: videoGame.id) { [weak self] in
                self?.isFavorite = false
                DispatchQueue.main.async { [weak self] in
                    self?.isDeleteObservable?(true)
                    self?.isFavoriteObservable?(false)
                }
            }
        } else {
            videoGameProvider.addVideoGame(videoGame: videoGame) { [weak self] in
                self?.isFavorite = true
                DispatchQueue.main.async { [weak self] in
                    self?.isDeleteObservable?(false)
                    self?.isFavoriteObservable?(true)
                }
            }
        }
    }
    
    // MARK: Private Functions
    private func retrieveGameDetailFromRemote(id: Int) {
        loadingObservable?(true)
        gameServicesNetworkModel.getGameDetails(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                let game = ObjectMapper.mapDetailVideoGameResponseToDetailVideoGameDomain(response: response)
                self?.videoGame = game
                self?.gameObservable?(game)
                self?.loadingObservable?(false)
            case .failure(let errorMessage):
                self?.loadingObservable?(false)
                self?.errorObservable?(errorMessage)
            }
        }
    }
    
    private func retrieveGameDetailFromLocal(id: Int) {
        loadingObservable?(true)
        videoGameProvider.getDetailVideoGame(id: id) { [weak self] game in
            DispatchQueue.main.async {
                self?.videoGame = game
                self?.gameObservable?(game)
                self?.loadingObservable?(false)
            }
        }
    }
    
    private func checkVideoGameFavoriteStatus(id: Int) {
        videoGameProvider.getIsVideoGameFavorited(id: id) { [weak self] isFavorite in
            self?.isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                self?.isFavoriteObservable?(isFavorite)
            }
        }
    }
}
