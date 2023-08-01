//
//  HomeInteractor.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 01/08/23.
//

import Combine

protocol HomeUseCase {
    func getGames() -> AnyPublisher<[VideoGame], Error>
    func getGamesByName(query: String) -> AnyPublisher<[VideoGame], Error>
    
}

class HomeInteractor: HomeUseCase {
    
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGames() -> AnyPublisher<[VideoGame], Error> {
        repository.getGames()
    }
    
    func getGamesByName(query: String) -> AnyPublisher<[VideoGame], Error> {
        repository.getGamesByName(query: query)
    }
    
}
