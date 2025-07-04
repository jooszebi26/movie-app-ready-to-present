//
//  PersionDetailResponse.swift
//  movie-app-live
//
//  Created by Szebasztian Joo on 2025. 06. 14..
//

//id = dto.id
//name = dto.name
//biography = dto.biography
//popularity = dto.popularity
//imagePath = dto.profilePath
//originPlace = dto.placeOfBirth
//birthYear = dto.birthday


import Foundation

struct PersonDetailResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let biography: String
    let imagePath: String?
    let originPlace: String
    let birthYear: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, birthYear
        case imagePath = "profile_path"
        case originPlace = "place_of_birth"
    }
    
    var logoURL: URL? {
        guard let logoPath = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
    }
}
