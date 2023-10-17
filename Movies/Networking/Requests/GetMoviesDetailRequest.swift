//
//  GetMoviesDetailRequest.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import Foundation
import Alamofire

class GetMoviesDetailRequest: BaseRequest {
    
    deinit {
        print("GetMoviesDetailRequest deinit")
    }
    
    private let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    override func parameters() -> [String : Any]? {
        var params: [String : Any] = [
            "language": "en-US"
        ]
        
        return params
        
    }
    
    override func apiPath() -> String? {
        let path = Defines.getMovieDetail
        return "\(path)/\(movieId)"
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    func perform(completion: @escaping RequestClosure<MoviesDetailModel>) {
        RequestManager.shared.performRequest(self, to: MoviesDetailModel.self, completion: completion)
    }
    
    override func headers() -> [String : String]? {
        let token = Defines.accessToken
        return ["Authorization" : "Bearer \(token)",
                "accept" : "application/json"]
    }
    
    var encoding: ParameterEncoding { return JSONEncoding.default }
}
