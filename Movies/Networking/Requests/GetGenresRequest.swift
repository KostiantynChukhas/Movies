//
//  GetGenresRequest.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import Alamofire

class GetGenresRequest: BaseRequest {
    
    deinit {
        print("GetGenresRequest deinit")
    }
    
    
    override func apiPath() -> String? {
        let path = Defines.getGenres
        return path
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    func perform(completion: @escaping RequestClosure<GenresModel>) {
        RequestManager.shared.performRequest(self, to: GenresModel.self, completion: completion)
    }
    
    override func headers() -> [String : String]? {
        let token = Defines.accessToken
        return ["Authorization" : "Bearer \(token)",
                "accept" : "application/json"]
    }
    
    var encoding: ParameterEncoding { return JSONEncoding.default }
}

