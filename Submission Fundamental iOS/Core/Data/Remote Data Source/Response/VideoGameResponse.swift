//
//  VideoGameResponse.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import Foundation

struct ListVideoGameResponse: Codable {
    let results: [VideoGameResponse]
}

struct VideoGameResponse: Codable {
    let id: Int
    let name: String
    let backgroundImage, released: String?
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
}
