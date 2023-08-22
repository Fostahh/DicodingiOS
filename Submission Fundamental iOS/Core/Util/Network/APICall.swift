//
//  APICall.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 01/08/23.
//

import Foundation

struct API {
    static let baseUrl = "https://api.rawg.io/api/games"
    static var key: String {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'TMDB-Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    
    enum Gets: Endpoint {
        case games
        case detailGame(id: Int)
        case search(query: String)
        
        public var url: String {
            switch self {
            case .games:
                return "\(API.baseUrl)?key=\(API.key)"
            case .detailGame(let id):
                return "\(API.baseUrl)/\(id)?key=\(API.key)"
            case .search(let query):
                return "\(API.baseUrl)?key=\(API.key)&search=\(query)"
            }
        }
    }
    
}
