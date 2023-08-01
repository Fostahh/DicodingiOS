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
    
    static func mapListVideoGameResponseToListVideoGameDomain(videoGames: [VideoGameEntity]) -> [VideoGame] {
        videoGames.map { entity in
            VideoGame(
                id: entity.id,
                name: entity.name,
                released: entity.released,
                backgroundImage: entity.backgroundImage,
                rating: entity.rating
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
            }),
            isFavorite: false
        )
    }
    
    static func mapDetailVideoGameEntityToDetailVideoGameDomain(entity: VideoGameEntity) -> DetailVideoGame {
        DetailVideoGame(
            id: entity.id,
            name: entity.name,
            description: entity.desc,
            backgroundImage: entity.backgroundImage,
            released: entity.released,
            backgroundImageAdditional: entity.backgroundImageAdditional,
            rating: entity.rating,
            esrbRating: ESRBRating(id: entity.esrbRating?.id ?? 0, name: entity.esrbRating?.name ?? "Everyone"),
            genres: entity.genres.map({ genreEntity in
                Genre(id: genreEntity.id, name: genreEntity.name)
            }),
            developers: entity.developers.map({ developerEntity in
                Developer(id: developerEntity.id, name: developerEntity.name)
            }),
            isFavorite: true
        )
    }
    
    static func mapDetailVideoGameDomainToDetailVideoGameEntity(domain: DetailVideoGame) -> VideoGameEntity {
        let videoGameEntity = VideoGameEntity()
        
        videoGameEntity.id = domain.id
        videoGameEntity.name = domain.name
        videoGameEntity.rating = domain.rating
        videoGameEntity.released = domain.released
        videoGameEntity.desc = domain.description
        videoGameEntity.backgroundImage = domain.backgroundImage
        videoGameEntity.backgroundImageAdditional = domain.backgroundImageAdditional
        
        let genresEntity: [GenreEntity] = {
            var genreEntities = [GenreEntity]()
            domain.genres.forEach { domainGenre in
                let genreEntity = GenreEntity()
                genreEntity.id = domainGenre.id
                genreEntity.name = domainGenre.name
                genreEntities.append(genreEntity)
            }
            return genreEntities
        }()
        videoGameEntity.genres.append(objectsIn: genresEntity)
        
        let esrbRatingEntity = ESRBRatingEntity()
        esrbRatingEntity.id = domain.esrbRating.id
        esrbRatingEntity.name = domain.esrbRating.name
        videoGameEntity.esrbRating = esrbRatingEntity
        
        let developersEntity: [DeveloperEntity] = {
            var developerEntities = [DeveloperEntity]()
            domain.developers.forEach { domainDeveloper in
                let developerEntity = DeveloperEntity()
                developerEntity.id = domainDeveloper.id
                developerEntity.name = domainDeveloper.name
                developerEntities.append(developerEntity)
            }
            return developerEntities
        }()
        videoGameEntity.developers.append(objectsIn: developersEntity)
        
        return videoGameEntity
    }
    
    
}
