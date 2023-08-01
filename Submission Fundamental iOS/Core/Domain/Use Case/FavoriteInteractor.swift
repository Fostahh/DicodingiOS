//
//  FavoriteInteractor.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 16/08/23.
//

import Combine

protocol FavoriteUseCase {
    func getGames() -> AnyPublisher<[VideoGame], Error>
}

class FavoriteInteractor: FavoriteUseCase {
    
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGames() -> AnyPublisher<[VideoGame], Error> {
        repository.getFavoriteGames()
    }
    
}
