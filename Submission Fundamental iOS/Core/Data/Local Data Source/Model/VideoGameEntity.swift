//
//  VideoGameEntity.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 11/08/23.
//

import Foundation
import RealmSwift

class VideoGameEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var rating: Double
    @Persisted var released: String
    @Persisted var desc: String
    @Persisted var backgroundImage: String
    @Persisted var backgroundImageAdditional: String
    @Persisted var genres: List<GenreEntity>
    @Persisted var esrbRating: ESRBRatingEntity?
    @Persisted var developers: List<DeveloperEntity>
}

class GenreEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
}

class DeveloperEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
}

class ESRBRatingEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
}
