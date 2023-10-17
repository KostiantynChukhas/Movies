//
//  Defines.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
typealias EmptyClosureType = () -> ()
typealias SimpleClosure<T> = (T) -> ()

enum CompletionResult {
    case success(Any?)
    case failure(String?)
}

typealias CompletionResultHandler = (CompletionResult) -> ()

struct Defines {
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0Yjg0MjJlMjU1OTIyMDdmZTI5MWFjMGEyNjRjY2MwMyIsInN1YiI6IjY1MmQzNjgwNjYxMWI0MDExYzFmYjE2ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Oso_XANP5WN1mAh7iFR12tyHEyYuvSpeiHMPexhm4gY"
    
    static let baseEndpoint = URL(string: "https://api.themoviedb.org/3")!
    static let getMovies: String = "\(baseEndpoint)/discover/movie"
    static let getGenres: String = "\(baseEndpoint)/genre/movie/list"
    static let searchMovies: String = "\(baseEndpoint)/search/movie"
    static let getMovieDetail: String = "\(baseEndpoint)/movie"
    static let getVideo: String = "\(baseEndpoint)/movie"

}

enum DateFormat {
    /// Style:  yyyy-MM-dd'T'HH:mm:ssZ
    static let fromServer = "yyyy-MM-dd'T'HH:mm:ssZ"
    /// Style:  yyyy-MM-dd HH:mm:ss
    static let forServer = "yyyy-MM-dd HH:mm:ss"
    /// Style:  yyyy-MM-dd
    static let toServer = "yyyy-MM-dd"
    /// Style:  dd.MM.yyyy
    static let defaultDesign = "dd.MM.yyyy"
    static let defaultDesignWithTime = "dd.MM.yyyy HH:mm"
    static let time = "HH:mm"
    static let monthId = "MM-yyyy"
    static let monthTitleId = "MM"
    static let year = "yyyy"
}
