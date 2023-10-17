//
//  BaseRequest.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import UIKit
import Alamofire

protocol BaseRequestProtocol {

    func mockDataName() -> String?
    func method() -> HTTPMethod
    func apiPath() -> String?
    func headers() -> [String : String]?
    func parameters() -> [String : Any]?
    func rawData() -> Data?
    func encoding() -> ParameterEncoding
}

protocol CustomMap {
    
    func initMapping<T>(_ type: T.Type, dict: [String: Any]) -> T?
}

class BaseRequest: BaseRequestProtocol {

    func mockDataName() -> String? {
        return nil
    }
    
    func method() -> HTTPMethod {
        return .post
    }

    func apiPath() ->String? {
        return nil
    }
    
    func headers() -> [String : String]? {
        return nil
    }
    
    func parameters() -> [String : Any]? {
        return nil
    }
    
    func rawData() -> Data? {
        return nil
    }

    func encoding() -> ParameterEncoding {
        switch method() {
            case .get:
                return URLEncoding.default
            case .post:
                return JSONEncoding.default
            default:
                return JSONEncoding.default
        }
    }

    func performRequest<T:Decodable>(to classType: T.Type, completion: @escaping RequestClosure<T>) {
        RequestManager.shared.performRequest(self, to: classType, completion: completion)
    }
}

enum ResponseType {
    case success(r: Any)
    case error(e: String)
}
