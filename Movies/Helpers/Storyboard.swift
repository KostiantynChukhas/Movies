//
//  Storyboard.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import UIKit

enum Storyboard {
    static let movies = storyboard(name: "Movies")
    static let moviesDetail = storyboard(name: "MoviesDetail")
}

private func storyboard(name: String, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: bundle)
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

// MARK: - UIStoryboard + instantiate -

extension UIStoryboard {
    func instantiate<T: StoryboardIdentifiable>() -> T {
        guard let controller = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Controller is nil with the identifier: \(T.storyboardIdentifier)")
        }
        return controller
    }
}

// MARK: - StoryboardIdentifiable -

extension UIViewController: StoryboardIdentifiable {}

// MARK: - StoryboardIdentifiable where Self: UIViewController -

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}
