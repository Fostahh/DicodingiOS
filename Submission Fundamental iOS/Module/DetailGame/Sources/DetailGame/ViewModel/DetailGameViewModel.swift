//
//  DetailGameViewModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import Foundation
import Combine
import Core

public class DetailGameViewModel {
    
    // MARK: - Init
    public init(
        useCase: DetailUseCase,
        gameId: Int
    ) {
        self.useCase = useCase
        self.gameId = gameId
    }
    
    // MARK: - Public Properties
    var gameObservable = PassthroughSubject<DetailVideoGame, Never>()
    var loadingObservable = PassthroughSubject<Bool, Never>()
    var errorObservable = PassthroughSubject<String, Never>()
    var isFavoriteObservable = PassthroughSubject<Bool, Never>()
    var showAlertObservable = PassthroughSubject<(Bool, String), Never>()
    
    // MARK: - Private Properties
    private let useCase: DetailUseCase
    private var videoGame: DetailVideoGame?
    private var cancellables: Set<AnyCancellable> = []
    
    private let gameId: Int
    
    // MARK: - Public Functions
    func viewDidLoad() {
        retrieveGameDetail(id: gameId)
    }
    
    func updateVideoGameFavoriteStatus() {
        guard var videoGame = videoGame else {
            return
        }
        
        if videoGame.isFavorite {
            useCase.deleteVideoGame(id: videoGame.id)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.loadingObservable.send(false)
                        self?.errorObservable.send(error.localizedDescription)
                    case .finished:
                        self?.loadingObservable.send(false)
                    }
                }, receiveValue: { [weak self] isSuccess in
                    if isSuccess {
                        videoGame.isFavorite = false
                        self?.videoGame = videoGame
                        self?.isFavoriteObservable.send(false)
                        self?.showAlertObservable.send((true, "Video Game Unfavorited."))
                    }
                })
                .store(in: &cancellables)
        } else {
            useCase.addGame(detailVideoGame: videoGame)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.loadingObservable.send(false)
                        self?.errorObservable.send(error.localizedDescription)
                    case .finished:
                        self?.loadingObservable.send(false)
                    }
                }, receiveValue: { [weak self] isSuccess in
                    if isSuccess {
                        videoGame.isFavorite = true
                        self?.videoGame = videoGame
                        self?.isFavoriteObservable.send(true)
                        self?.showAlertObservable.send((true, "Video Game Favorited."))
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    // MARK: Private Methods
    private func retrieveGameDetail(id: Int) {
        loadingObservable.send(true)
        
        useCase.getGameDetails(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.loadingObservable.send(false)
                    self?.errorObservable.send(error.localizedDescription)
                case .finished:
                    self?.loadingObservable.send(false)
                }
            }, receiveValue: { [weak self] game in
                self?.videoGame = game
                self?.isFavoriteObservable.send(game.isFavorite)
                self?.gameObservable.send(game)
            })
            .store(in: &cancellables)
    }
    
}
