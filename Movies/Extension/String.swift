//
//  String.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit

extension String {
    func trimAllSpace() -> String {
         return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
