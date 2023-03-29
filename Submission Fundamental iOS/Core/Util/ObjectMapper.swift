//
//  ObjectMapper.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import Foundation

public final class ObjectMapper {
    static func mapListVideoGameResponseToListVideoGameDomain(videoGames: [VideoGameResponse]) -> [VideoGame] {
        videoGames.map { response in
            VideoGame(
                id: response.id,
                name: response.name,
                released: response.released ?? "Unknown",
                backgroundImage: response.backgroundImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEaYTaC-q-QWUu2g7QgVvRKkJkqXjXtjBU2w&usqp=CAU",
                rating: response.rating
            )
        }
    }
    
    static func mapDetailVideoGameResponseToDetailVideoGameDomain(response: DetailVideoGameResponse) -> DetailVideoGame {
        DetailVideoGame(
            id: response.id,
            name: response.name,
            description: response.description,
            backgroundImage: response.backgroundImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEaYTaC-q-QWUu2g7QgVvRKkJkqXjXtjBU2w&usqp=CAU",
            released: response.released ?? "Unknown",
            backgroundImageAdditional: response.backgroundImageAdditional ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEaYTaC-q-QWUu2g7QgVvRKkJkqXjXtjBU2w&usqp=CAU",
            rating: response.rating,
            esrbRating: ESRBRating(id: response.esrbRating?.id ?? 0, name: response.esrbRating?.name ?? "Everyone"),
            genres: response.genres.map({ genreResponse in
                Genre(id: genreResponse.id, name: genreResponse.name)
            }),
            developers: response.developers.map({ developerResponse in
                Developer(id: developerResponse.id, name: developerResponse.name)
            })
        )
    }
}
