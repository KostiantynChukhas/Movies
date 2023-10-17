//
//  GetVideoRequest.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import Foundation
import Alamofire

class GetVideoRequest: BaseRequest {
    
    deinit {
        print("GetVideoRequest deinit")
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
        let path = Defines.getVideo
        return "\(path)/\(movieId)/videos"
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    func perform(completion: @escaping RequestClosure<VideoModel>) {
        RequestManager.shared.performRequest(self, to: VideoModel.self, completion: completion)
    }
    
    override func headers() -> [String : String]? {
        let token = Defines.accessToken
        return ["Authorization" : "Bearer \(token)",
                "accept" : "application/json"]
    }
    
    var encoding: ParameterEncoding { return JSONEncoding.default }
}
