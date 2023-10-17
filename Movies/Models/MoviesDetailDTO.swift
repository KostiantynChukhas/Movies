//
//  MoviesDetailDTO.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import Foundation
struct MoviesDetailDTO: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let dateString: String
    let country: String
    let imgUrlString: String
    let genre: [String]
    let rating: Double
    let youtubeLink: String
}

extension MoviesDetailDTO {
    func getYearFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)"
        
    }
    
    func getRating() -> String {
        let truncatedNumber = Double(String(format: "%.1f", rating))!
        return "\(truncatedNumber)"
    }
}
