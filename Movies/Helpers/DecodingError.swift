//
//  DecodingError.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
extension DecodingError {
    
    public var localizedDebugInfo: String? {
        switch  self {
            case .dataCorrupted(let context):
                return NSLocalizedString(context.debugDescription, comment: "")
            case .keyNotFound(_, let context):
                return NSLocalizedString("\(context.debugDescription)", comment: "")
            case .typeMismatch(_, let context):
                return NSLocalizedString("\(context.debugDescription)", comment: "")
            case .valueNotFound(_, let context):
                return NSLocalizedString("\(context.debugDescription)", comment: "")
        }
    }
}
