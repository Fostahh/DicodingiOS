//
//  FavoriteViewModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 02/04/23.
//

import Foundation
import Combine

class FavoriteViewModel {
    
    // MARK: Public Properties
    var gamesObservable = PassthroughSubject<[VideoGame], Never>()
    var loadingObservable = PassthroughSubject<Bool, Never>()
    var errorObservable = PassthroughSubject<String, Never>()
    
    // MARK: Private Properties
    private let useCase: FavoriteUseCase
    private var videoGames: [VideoGame] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(useCase: FavoriteUseCase) {
        self.useCase = useCase
    }
    
    func retrieveGames() {
        loadingObservable.send(true)
        useCase.getGames()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorObservable.send(error.localizedDescription)
                    self?.loadingObservable.send(false)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] videoGames in
                self?.loadingObservable.send(false)
                if videoGames.isEmpty {
                    self?.errorObservable.send("You don't have favorite video games")
                } else {
                    self?.videoGames = videoGames
                    self?.gamesObservable.send(videoGames)
                }
            })
            .store(in: &cancellables)
    }
    
    func getVideoGamesSize() -> Int {
        videoGames.count
    }
    
    func getVideoGame(indexPath: Int) -> VideoGame {
        videoGames[indexPath]
    }
}
