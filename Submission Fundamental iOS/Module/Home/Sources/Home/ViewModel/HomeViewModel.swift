//
//  HomeViewModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import Foundation
import Combine
import Core

public class HomeViewModel {
    
    // MARK: - Init
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Public Properties
    var gamesObservable = PassthroughSubject<[VideoGame], Never>()
    var loadingObservable = PassthroughSubject<Bool, Never>()
    var errorObservable = PassthroughSubject<String, Never>()
    
    // MARK: Private Properties
    private let useCase: HomeUseCase
    private var videoGames: [VideoGame] = []
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Public Functions
    func retrieveGames() {
        loadingObservable.send(true)
        useCase.getGames()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorObservable.send(error.localizedDescription)
                    self?.loadingObservable.send(false)
                case .finished:
                    self?.loadingObservable.send(false)
                }
            }, receiveValue: { [weak self] videoGames in
                self?.gamesObservable.send(videoGames)
                self?.videoGames = videoGames
            })
            .store(in: &cancellables)
    }
    
    func getVideoGamesSize() -> Int {
        videoGames.count
    }
    
    func getVideoGame(indexPath: Int) -> VideoGame {
        videoGames[indexPath]
    }
    
    func retrieveGamesByName(query: String) {
        loadingObservable.send(true)
        useCase.getGamesByName(query: query)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorObservable.send(error.localizedDescription)
                    self?.loadingObservable.send(false)
                case .finished:
                    self?.loadingObservable.send(false)
                }
            }, receiveValue: { [weak self] videoGames in
                self?.gamesObservable.send(videoGames)
                self?.videoGames = videoGames
            })
            .store(in: &cancellables)
    }
    
}
