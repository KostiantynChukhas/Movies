//
//  GetMoviesRequest.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import Alamofire

class GetMoviesRequest: BaseRequest {
    
    deinit {
        print("GetMoviesRequest deinit")
    }
    
    private var searchText: String
    private var filterType: FilterType
    private let page: Int
    
    init(searchText: String,
         page: Int,
         filterType: FilterType) {
        self.searchText = searchText
        self.filterType = filterType
        self.page = page
    }
    
    override func parameters() -> [String : Any]? {
        var params: [String : Any] = [
            "include_adult" : false,
            "include_video": false,
            "language": "en-US",
            "page": self.page
        ]
        
        if !searchText.isEmpty {
            params["query"] = searchText
        }
        
        if !filterType.rawValue.isEmpty {
            params["sort_by"] = filterType.getPath()
        }
        
        
        
        return params
        
    }
    
    override func apiPath() -> String? {
        let path = searchText.isEmpty ? Defines.getMovies : Defines.searchMovies
        return path
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    func perform(completion: @escaping RequestClosure<MovieModel>) {
        RequestManager.shared.performRequest(self, to: MovieModel.self, completion: completion)
    }
    
    override func headers() -> [String : String]? {
        let token = Defines.accessToken
        return ["Authorization" : "Bearer \(token)",
                "accept" : "application/json"]
    }
    
    var encoding: ParameterEncoding { return JSONEncoding.default }
}
