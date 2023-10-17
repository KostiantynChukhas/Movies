//
//  MoviesDTO.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit

struct MoviesDTO: Codable, Hashable {
    let id: Int
    let title: String
    let dateString: String
    let imgUrlString: String
    let genre: [String]
    let rating: Double
}

extension MoviesDTO {
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
