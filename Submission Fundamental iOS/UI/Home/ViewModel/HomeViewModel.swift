//
//  HomeViewModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import Foundation

typealias Observer<T> = (T) -> Void

class HomeViewModel {
    
    // MARK: Public Properties
    var gamesObservable: Observer<[VideoGame]>?
    var loadingObservable: Observer<Bool>?
    var errorObservable: Observer<String>?
    
    // MARK: Private Properties
    private let gameServicesNetworkModel: GameServicesNetworkModel
    private var videoGames: [VideoGame] = []
    
    init(gameServicesNetworkModel: GameServicesNetworkModel) {
        self.gameServicesNetworkModel = gameServicesNetworkModel
    }
    
    // MARK: Public Functions
    func retrieveGames() {
        loadingObservable?(true)
        gameServicesNetworkModel.getGames { [weak self] result in
            switch result {
            case .success(let gamesResponse):
                let games = ObjectMapper.mapListVideoGameResponseToListVideoGameDomain(videoGames: gamesResponse)
                self?.videoGames = games
                self?.gamesObservable?(games)
                self?.loadingObservable?(false)
            case .failure(let errorMessage):
                self?.loadingObservable?(false)
                self?.errorObservable?(errorMessage)
            }
        }
    }
    
    func getVideoGamesSize() -> Int {
        videoGames.count
    }
    
    func getVideoGame(indexPath: Int) -> VideoGame {
        videoGames[indexPath]
    }
    
    func retrieveGamesByName(query: String) {
        loadingObservable?(true)
        gameServicesNetworkModel.getGamesByName(query: query) { [weak self] result in
            switch result {
            case .success(let gamesResponse):
                let games = ObjectMapper.mapListVideoGameResponseToListVideoGameDomain(videoGames: gamesResponse)
                self?.videoGames = games
                self?.gamesObservable?(games)
                self?.loadingObservable?(false)
            case .failure(let errorMessage):
                self?.loadingObservable?(false)
                self?.errorObservable?(errorMessage)
            }
        }
    }
}
