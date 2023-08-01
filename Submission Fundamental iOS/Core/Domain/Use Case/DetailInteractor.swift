//
//  DetailInteractor.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 01/08/23.
//

import Combine

protocol DetailUseCase {
    func getGameDetails(id: Int) -> AnyPublisher<DetailVideoGame, Error>
    func addGame(detailVideoGame: DetailVideoGame) -> AnyPublisher<Bool, Error>
    func deleteVideoGame(id: Int) -> AnyPublisher<Bool, Error>
}

class DetailInteractor: DetailUseCase {
    
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGameDetails(id: Int) -> AnyPublisher<DetailVideoGame, Error> {
        repository.getGameDetails(id: id)
    }
    
    func addGame(detailVideoGame: DetailVideoGame) -> AnyPublisher<Bool, Error> {
        repository.addGame(from: detailVideoGame)
    }
    
    func deleteVideoGame(id: Int) -> AnyPublisher<Bool, Error> {
        repository.deleteVideoGame(id: id)
    }
}
