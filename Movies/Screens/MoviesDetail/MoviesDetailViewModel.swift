//
//  MoviesDetailViewModel.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import Foundation

protocol MoviesDetailViewModelType {
    var onReload: EmptyClosureType? { get set }
    var detailModel: MoviesDetailDTO? { get }

}

class MoviesDetailViewModel: MoviesDetailViewModelType {
    
    private let coordinator: MoviesDetailCoordinatorType
    private var moviesService: MoviesServiceType
    
    private var movieId: Int
    
    var onReload: EmptyClosureType? = { }
    var detailModel: MoviesDetailDTO?
    
    init(_ coordinator: MoviesDetailCoordinatorType, movieId: Int) {
        self.coordinator = coordinator
        self.moviesService = ServiceHolder.shared.get(by: MoviesService.self)
        self.movieId = movieId
        self.getDetail()
    }
    
    private func getDetail() {
        moviesService.getMovieDetail(with: movieId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.detailModel = response
                self?.onReload?()
            case .error(let message):
                print(message)
            }
        }
    }
    
    deinit {
        print("MoviesDetailViewModel - deinit")
    }
}
