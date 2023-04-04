//
//  DetailVideoGameResponse.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import Foundation

struct DetailVideoGameResponse: Codable {
    let id: Int
    let name, description: String
    let backgroundImage, released, backgroundImageAdditional: String?
    let rating: Double
    let esrbRating: ESRBRatingResponse?
    let genres: [GenreResponse]
    let developers: [DeveloperResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, genres, developers
        case description = "description_raw"
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case rating
        case esrbRating = "esrb_rating"
    }
}

struct ESRBRatingResponse: Codable {
    let id: Int
    let name: String
}

struct GenreResponse: Codable {
    let id: Int
    let name: String
}

struct DeveloperResponse: Codable {
    let id: Int
    let name: String
}
