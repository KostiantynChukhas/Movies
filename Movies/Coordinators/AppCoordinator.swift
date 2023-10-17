//
//  AppCoordinator.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import UIKit
class AppCoordinator {
    
    private var window: UIWindow
    private let serviceHolder = ServiceHolder.shared
    private var moviesCoordinator: MoviesCoordinator?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = self.root
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        startInitialServices()
        enterApp()
    }
    
    private func enterApp() {
        moviesCoordinator = MoviesCoordinator(navigationController: root)
        moviesCoordinator?.start()
    }
}

//MARK: - Services routine -

extension AppCoordinator {
    
    private func startInitialServices() {
        
        let moviesService = MoviesService()
        serviceHolder.add(MoviesService.self, for: moviesService)
    }
}
