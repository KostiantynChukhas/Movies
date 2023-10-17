//
//  MoviesDetailDetailCoordinator.swift
//  MoviesDetail
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import UIKit

protocol MoviesDetailCoordinatorTransitions: AnyObject {
}

protocol MoviesDetailCoordinatorType: AnyObject {
    func start()
    func back()
}

class MoviesDetailCoordinator: MoviesDetailCoordinatorTransitions, MoviesDetailCoordinatorType {

    weak var transitions: MoviesDetailCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: MoviesDetailViewController? = Storyboard.moviesDetail.instantiate()
    
    init(navigationController: UINavigationController?, movieId: Int) {
        self.navigationController = navigationController
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        controller?.viewModel = MoviesDetailViewModel(self, movieId: movieId)
    }
    
    deinit {
        print("MoviesDetailCoordinator - deinit")
    }
}


// MARK: - Navigation -

extension MoviesDetailCoordinator {
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func back() {
        navigationController?.dismiss(animated: true)
    }
}
