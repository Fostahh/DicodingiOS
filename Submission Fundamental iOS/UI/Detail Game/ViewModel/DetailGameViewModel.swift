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
    
    // MARK: Private Properties
    private let gameServicesNetworkModel: GameServicesNetworkModel
    private var videoGame: DetailVideoGame? = nil
    
    init(gameServicesNetworkModel: GameServicesNetworkModel) {
        self.gameServicesNetworkModel = gameServicesNetworkModel
    }
    
    // MARK: Public Functions
    func retrieveGameDetail(id: Int) {
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
    
}
