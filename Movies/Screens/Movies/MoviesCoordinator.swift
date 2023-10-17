//
//  MoviesCoordinator.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit

protocol MoviesCoordinatorTransitions: AnyObject {
}

protocol MoviesCoordinatorType: AnyObject {
    func showDetail(with id: Int)
    func start()
}

class MoviesCoordinator: MoviesCoordinatorTransitions, MoviesCoordinatorType {
    weak var transitions: MoviesCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: MoviesViewController? = Storyboard.movies.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        controller?.viewModel = MoviesViewModel(self)
    }

    deinit {
        print("MoviesCoordinator - deinit")
    }
}


// MARK: - Navigation -

extension MoviesCoordinator {

     func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }

     func showDetail(with id: Int) {
        let coordinator = MoviesDetailCoordinator(navigationController: navigationController, movieId: id)
        coordinator.start()
    }
}
