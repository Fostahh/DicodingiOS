//
//  GameServicesNetworkModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import Foundation

enum GameNetworkResult {
    case success([VideoGameResponse])
    case failure(String)
}

enum GameDetailNetworkResult {
    case success(DetailVideoGameResponse)
    case failure(String)
}

protocol GameServicesNetworkModel {
    func getGames(completion: @escaping (GameNetworkResult) -> Void)
    func getGamesByName(query: String, completion: @escaping (GameNetworkResult) -> Void)
    func getGameDetails(id: Int, completion: @escaping (GameDetailNetworkResult) -> Void)
}

final class GameServicesDefaultNetworkModel: GameServicesNetworkModel {
    private let apiKey = "e2037d96ffc84a45b3d9b74e9e3d5fea"
    
    func getGames(completion: @escaping (GameNetworkResult) -> Void) {
        let urlQueryItems  = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        var urlComponent = URLComponents(string: "https://api.rawg.io/api/games")!
        urlComponent.queryItems = urlQueryItems
        let url = urlComponent.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure("Data not found"))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ListVideoGameResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure("Failed to convert"))
                }
            }       
        }.resume()
    }
    
    func getGamesByName(query: String, completion: @escaping (GameNetworkResult) -> Void) {
        let urlQueryItems  = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "search", value: query)
        ]
        var urlComponent = URLComponents(string: "https://api.rawg.io/api/games")!
        urlComponent.queryItems = urlQueryItems
        let url = urlComponent.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure("Data not found"))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ListVideoGameResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure("Failed to convert"))
                }
            }
        }.resume()
    }
    
    func getGameDetails(id: Int, completion: @escaping (GameDetailNetworkResult) -> Void) {
        let urlQueryItems  = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        var urlComponent = URLComponents(string: "https://api.rawg.io/api/games/\(id)")!
        urlComponent.queryItems = urlQueryItems
        let url = urlComponent.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure("Data not found"))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(DetailVideoGameResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure("Failed to convert"))
                }
            }
        }.resume()
    }
}
