//
//  GameRepository.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 01/08/23.
//

import Combine

protocol GameRepositoryProtocol {
    func getGames() -> AnyPublisher<[VideoGame], Error>
    func getGamesByName(query: String) -> AnyPublisher<[VideoGame], Error>
    func getGameDetails(id: Int) -> AnyPublisher<DetailVideoGame, Error>
    func addGame(from detailVideoGame: DetailVideoGame) -> AnyPublisher<Bool, Error>
    func deleteVideoGame(id: Int) -> AnyPublisher<Bool, Error>
    func getFavoriteGames() -> AnyPublisher<[VideoGame], Error>
}

final class GameRepository: GameRepositoryProtocol {
    
    typealias GameInstance = (RemoteDataSource, LocalDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let local: LocalDataSource
    
    private init(remote: RemoteDataSource, local: LocalDataSource) {
        self.remote = remote
        self.local = local
    }
    
    static let sharedInstance: GameInstance = { (remoteRepo, localRepo) in
        return GameRepository(remote: remoteRepo, local: localRepo)
    }
    
    func getGames() -> AnyPublisher<[VideoGame], Error> {
        return self.remote.getGames()
            .map { ObjectMapper.mapListVideoGameResponseToListVideoGameDomain(videoGames: $0) }
            .eraseToAnyPublisher()
    }
    
    func getGamesByName(query: String) -> AnyPublisher<[VideoGame], Error> {
        return self.remote.getGamesByName(query: query)
            .map { ObjectMapper.mapListVideoGameResponseToListVideoGameDomain(videoGames: $0) }
            .eraseToAnyPublisher()
    }
    
    func getGameDetails(id: Int) -> AnyPublisher<DetailVideoGame, Error> {
        return self.local.getVideoGame(by: id)
            .flatMap { result -> AnyPublisher<DetailVideoGame, Error> in
                if let result = result {
                    return self.local.getVideoGame(by: id)
                        .map { _ in ObjectMapper.mapDetailVideoGameEntityToDetailVideoGameDomain(entity: result) }
                        .eraseToAnyPublisher()
                } else {
                    return self.remote.getGameDetails(id: id)
                        .map { ObjectMapper.mapDetailVideoGameResponseToDetailVideoGameDomain(response: $0) }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func addGame(from detailVideoGame: DetailVideoGame) -> AnyPublisher<Bool, Error> {
        return self.local.addVideoGame(
            from: ObjectMapper.mapDetailVideoGameDomainToDetailVideoGameEntity(domain: detailVideoGame)
        )
        .eraseToAnyPublisher()
    }
    
    func deleteVideoGame(id: Int) -> AnyPublisher<Bool, Error> {
        return self.local.deleteVideoGame(by: id)
    }
    
    func getFavoriteGames() -> AnyPublisher<[VideoGame], Error> {
        return self.local.getVideoGames()
            .map{ ObjectMapper.mapListVideoGameResponseToListVideoGameDomain(videoGames: $0) }
            .eraseToAnyPublisher()
    }
}
