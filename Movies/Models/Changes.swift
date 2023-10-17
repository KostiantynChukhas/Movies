//
//  Changes.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import UIKit

struct Changes {
    //indeces
    let inserted: [Int]
    let removed: [Int]
    let updated: [Int]
    
    init(inserted: [Int] = [], removed: [Int] = [], updated: [Int] = []) {
        self.inserted = inserted
        self.removed = removed
        self.updated = updated
    }
    
    init(inserted: Range<Int>? = nil, removed: Range<Int>? = nil, updated: Range<Int>? = nil) {
        if let inserted = inserted {
            self.inserted = Array(inserted)
        } else {
            self.inserted = []
        }
        
        if let removed = removed {
            self.removed = Array(removed)
        } else {
            self.removed = []
        }
        
        if let updated = updated {
            self.updated = Array(updated)
        } else {
            self.updated = []
        }
    }
    
    init(inserted: Int? = nil, removed: Int? = nil, updated: Int? = nil) {
        if let inserted = inserted {
            self.inserted = [inserted]
        } else {
            self.inserted = []
        }
        
        if let removed = removed {
            self.removed = [removed]
        } else {
            self.removed = []
        }
        
        if let updated = updated {
            self.updated = [updated]
        } else {
            self.updated = []
        }
    }
    
    init<T: Hashable>(new: [T], old: [T]) {
        var removed = [Int]()
        var inserted = [Int]()
        let difference = new.difference(from: old).inferringMoves()
        difference.forEach {
            switch $0 {
            case .remove(offset: let index, element: _, associatedWith: _):
                removed.append(index)
            case .insert(offset: let index, element: _, associatedWith: _):
                inserted.append(index)
            }
        }
        self.removed = removed
        self.inserted = inserted
        
        var updated = Array(old.indices) // all other
        updated.removeAll { inserted.contains($0) }
        updated.removeAll { removed.contains($0) }
        self.updated = updated
    }
}
