//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import Foundation
import NotificationBannerSwift

protocol MoviesViewModelType {
    var moviesList: [MoviesDTO] { get }
    var onReload: EmptyClosureType? { get set }
    
    func setup()
    func refresh()
    func addNextPaginationPage()
    func search(text: String)
    func filter(text: String)
    
    // navigation
    func showDetail(with id: Int)
}

class MoviesViewModel: MoviesViewModelType {
    
    private let coordinator: MoviesCoordinatorType
    private var moviesService: MoviesServiceType
    private var isPaginating = false
    private let bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 3)
    
    var moviesList: [MoviesDTO] = []
    var onReload: EmptyClosureType?
    
    init(_ coordinator: MoviesCoordinatorType) {
        self.coordinator = coordinator
        self.moviesService = ServiceHolder.shared.get(by: MoviesService.self)
    }
    
    func addNextPaginationPage() {
        guard moviesService.canPaginate,
              !isPaginating else { return }
        isPaginating = true
        moviesService.increasePage()
        getMovies()
    }
    
    func setup() {
        moviesService.setSearchName(nil)
        moviesService.resetPage()
        getMovies()
    }
    
    func refresh() {
        moviesService.resetPage()
        getMovies()
    }
    
    func filter(text: String) {
        moviesService.setFilter(text)
        moviesService.resetPage()
        getMovies()
    }
    
    func search(text: String) {
        if text.trimSpace().isEmpty {
            moviesService.setSearchName(nil)
        } else {
            moviesService.setSearchName(text)
        }
        
        moviesService.resetPage()
        getMovies()
    }
    
    private func getMovies() {
        moviesService.getMovies() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let changes = Changes(new: response, old: self.moviesList)
                self.moviesList = response
                if self.isPaginating {
                    self.onReload?()
                } else {
                    self.onReload?()
                }
                self.isPaginating = false
            case .error(let message):
                AlertHelper.showBanner(on: .topViewController,
                                       text: message ?? "",
                                       queue: self.bannerQueue)
            }
        }
    }
    
    deinit {
        print("MoviesViewModel - deinit")
    }
}

//MARK: - Navigation -
extension MoviesViewModel {
    func showDetail(with id: Int) {
        coordinator.showDetail(with: id)
    }
}
