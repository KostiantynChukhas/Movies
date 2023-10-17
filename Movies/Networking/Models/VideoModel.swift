//
//  VideoModel.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import Foundation

// MARK: - VideoModel
struct VideoModel: Codable {
    let id: Int?
    let results: [ResultVideo]?
}

// MARK: - Result
struct ResultVideo: Codable {
    let name, key: String?
    let site: String?
    let type: TypeEnum?
    let official: Bool?

    enum CodingKeys: String, CodingKey {
        case name, key, site, type, official
    }
}

enum TypeEnum: String, Codable {
    case behindTheScenes = "Behind the Scenes"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}
