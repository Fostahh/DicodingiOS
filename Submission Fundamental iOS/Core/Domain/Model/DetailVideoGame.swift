//
//  DetailVideoGame.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 23/03/23.
//

import Foundation

struct DetailVideoGame {
    let id: Int
    let name, description, backgroundImage, released, backgroundImageAdditional: String
    let rating: Double
    let esrbRating: ESRBRating
    let genres: [Genre]
    let developers: [Developer]
    var isFavorite: Bool = false
    
    var ageRestriction: String {
        switch esrbRating.id {
        case 2: return "10+"
        case 3: return "13+"
        case 4: return "18+"
        case 5: return "18+"
        default: return esrbRating.name
        }
    }
    
    var genresInString: String {
        var genreInString = ""
        
        for (index, genre) in genres.enumerated() {
            if index == genres.count - 1 {
                genreInString += genre.name
            } else {
                genreInString += genre.name + ", "
            }
            
        }
        
        return genreInString
    }
    
    var developersInString: String {
        var developerInString = ""
        
        for (index, developer) in developers.enumerated() {
            if index == developers.count - 1 {
                developerInString += developer.name
            } else {
                developerInString += developer.name + ", "
            }
            
        }
        
        return developerInString
    }
}

struct ESRBRating {
    let id: Int
    let name: String
}

struct Genre {
    let id: Int
    let name: String
}

struct Developer {
    let id: Int
    let name: String
}
