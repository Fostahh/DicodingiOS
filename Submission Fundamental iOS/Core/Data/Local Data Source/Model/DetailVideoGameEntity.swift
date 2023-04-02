//
//  DetailVideoGameEntity.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 02/04/23.
//

import Foundation

struct DetailVideoGameEntity {
    let id: Int
    let name, description, backgroundImage, released, backgroundImageAdditional: String
    let rating: Double
    let esrbRating: ESRBRatingEntity
    let genres: [GenreEntity]
    let developers: [DeveloperEntity]
}

struct ESRBRatingEntity {
    let id: Int
    let name: String
}

struct GenreEntity {
    let id: Int
    let name: String
}

struct DeveloperEntity {
    let id: Int
    let name: String
}
