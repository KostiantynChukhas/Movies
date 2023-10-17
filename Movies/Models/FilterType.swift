//
//  FilterType.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import Foundation

enum FilterType: String {
    case popularityDescending
    case popularityAscending
    case ratingDescending
    case ratingAscending
    case releaseDateDescending
    case releaseDateAscending

    func getPath() -> String {
        switch self {
            
        case .popularityDescending:
            return "popularity.desc"
        case .popularityAscending:
            return "popularity.asc"
        case .ratingDescending:
            return "revenue.desc"
        case .ratingAscending:
            return "revenue.asc"
        case .releaseDateDescending:
            return "primary_release_date.desc"
        case .releaseDateAscending:
            return "primary_release_date.asc"
        }
    }
    
    static func getByTitle(_ title: String) -> FilterType? {
           switch title {
           case NSLocalizedString("filter_popularityDescending"):
               return .popularityDescending
           case NSLocalizedString("filter_popularityAscending"):
               return .popularityAscending
           case NSLocalizedString("filter_ratingDescending"):
               return .ratingDescending
           case NSLocalizedString("filter_ratingAscending"):
               return .ratingAscending
           case NSLocalizedString("filter_releaseDateDescending"):
               return .releaseDateDescending
           case NSLocalizedString("filter_releaseDateAscending"):
               return .releaseDateAscending
           default:
               return nil
           }
       }
    
    var title: String {
        switch self {
        case .popularityDescending:
            return NSLocalizedString("filter_popularityDescending")
        case .popularityAscending:
            return NSLocalizedString("filter_popularityAscending")
        case .ratingDescending:
            return NSLocalizedString("filter_ratingDescending")
        case .ratingAscending:
            return NSLocalizedString("filter_ratingAscending")
        case .releaseDateDescending:
            return NSLocalizedString("filter_releaseDateDescending")
        case .releaseDateAscending:
            return NSLocalizedString("filter_releaseDateAscending")
        }
    }
    
}


