//
//  RemoteDataSource.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol {
    func getGames() -> AnyPublisher<[VideoGameResponse], Error>
    func getGamesByName(query: String) -> AnyPublisher<[VideoGameResponse], Error>
    func getGameDetails(id: Int) -> AnyPublisher<DetailVideoGameResponse, Error>
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    
    static let sharedInstance: RemoteDataSource =  RemoteDataSource()
    
    func getGames() -> AnyPublisher<[VideoGameResponse], Error> {
        return Future<[VideoGameResponse], Error> { completion in
            if let url = URL(string: Endpoints.Gets.games.url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: ListVideoGameResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getGamesByName(query: String) -> AnyPublisher<[VideoGameResponse], Error> {
        return Future<[VideoGameResponse], Error> { completion in
            if let url = URL(string: Endpoints.Gets.search(query: query).url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: ListVideoGameResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getGameDetails(id: Int) -> AnyPublisher<DetailVideoGameResponse, Error> {
        return Future<DetailVideoGameResponse, Error> { completion in
            if let url = URL(string: Endpoints.Gets.detailGame(id: id).url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: DetailVideoGameResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
}
