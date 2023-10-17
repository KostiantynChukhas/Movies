//
//  MoviesService.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//


import Foundation


protocol MoviesServiceType: Service {
    //getters
    var canPaginate: Bool { get }
    //setters
    func increasePage()
    func resetPage()
    func setSearchName(_ text: String?)
    func setFilter(_ text: String)
    
    func getMovies(completion: @escaping( RequestResultCodable<[MoviesDTO]> ) -> Void)
    func getMovieDetail(with movieId: Int, completion: @escaping(RequestResultCodable<MoviesDetailDTO>) -> Void)
}

class MoviesService: MoviesServiceType {
    
    private var genres: [Genre] = []
    private var movies: [MoviesDTO] = []
    private var searchText: String = ""
    private var filterType: FilterType = .popularityDescending
    private var currentPage = 1
    private var lastPage: Int?
    
    init() {
        getGanres()
    }
    
    //MARK: - Getters
    var canPaginate: Bool {
        guard let lastPage = lastPage else { return false }
        return currentPage < lastPage
    }
    
    //MARK: - Setters
    func increasePage() {
        currentPage += 1
    }

    func resetPage() {
        self.movies = []
        currentPage = 1
    }
    
    func setSearchName(_ text: String?) {
        searchText = text ?? ""
    }
    
    func setFilter(_ text: String) {
        if let filterType = FilterType.getByTitle(text) {
            self.filterType = filterType
        }
    }
}

extension MoviesService {
    func getMovies(completion: @escaping(RequestResultCodable<[MoviesDTO]>) -> Void) {
        let reguest = GetMoviesRequest(searchText: self.searchText, page: currentPage, filterType: filterType)
        reguest.performRequest(to: MovieModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .error(let error):
                completion(.error(message: error))
            case .success(response: let response):
                self.lastPage = response.totalPages ?? 0
                if self.currentPage == 1 {
                    self.movies = self.convertDTO(with: response)
                } else {
                    self.movies += self.convertDTO(with: response)
                }
                
                completion(.success(response: self.movies))
            }
        }
    }
   
    private func getGanres() {
        let reguest = GetGenresRequest()
        reguest.performRequest(to: GenresModel.self) { result in
            switch result {
            case .error(let error):
                print(error)
            case .success(response: let response):
                self.genres = response.genres ?? []
            }
        }
    }
    
    func getMovieDetail(with movieId: Int, completion: @escaping(RequestResultCodable<MoviesDetailDTO>) -> Void) {
        let reguest = GetMoviesDetailRequest(movieId: movieId)
        reguest.performRequest(to: MoviesDetailModel.self) { result in
            switch result {
            case .error(let error):
                completion(.error(message: error))
            case .success(response: let response):
                self.makeMovieDetail(with: response) { moviesDetailModel in
                    guard let model = moviesDetailModel else { return }
                    completion(.success(response: model))
                }
            }
        }
    }
   
   private func getVideo(by id: Int, completion: @escaping SimpleClosure<[ResultVideo]?>) {
        let reguest = GetVideoRequest(movieId: id)
        reguest.performRequest(to: VideoModel.self) { result in
            switch result {
            case .error:
                completion(nil)
            case .success(response: let response):
                completion(response.results)
            }
        }
    }
}

extension MoviesService {
    
    private func convertDTO(with model: MovieModel) -> [MoviesDTO] {
        let list: [MoviesDTO] = model.results?.compactMap({ result in
            MoviesDTO(
                id: result.id ?? 0,
                title: result.title ?? "",
                dateString: result.releaseDate ?? "",
                imgUrlString: "https://image.tmdb.org/t/p/original/\(result.posterPath ?? "")",
                genre: self.getGenres(with: result.genreIDS ?? []),
                rating: result.voteAverage ?? 0
            )
        }) ?? []
        
        return list
    }
    
    private func getGenres(with genreIds: [Int]) -> [String] {
        var genreNames: [String] = []
        for id in genreIds {
            if let genre = genres.first(where: { $0.id == id }), let genreName = genre.name {
                genreNames.append(genreName)
            }
        }
        return genreNames
    }
    
    private func makeMovieDetail(with model: MoviesDetailModel, completion: @escaping SimpleClosure<MoviesDetailDTO?>) {
        getVideo(by: model.id ?? 0) { resultModel in
            let genre: [String] = model.genres?.compactMap { $0.name } ?? []
            let youtubeKey = resultModel?.filter { $0.official == true && $0.site == "YouTube" }.first?.key ?? ""
            let movieDetailDTO = MoviesDetailDTO(id: model.id ?? 0,
                                                name: model.originalTitle ?? "",
                                                description: model.overview ?? "",
                                                dateString: model.releaseDate ?? "",
                                                country: model.productionCountries?.last?.name ?? "",
                                                imgUrlString: "https://image.tmdb.org/t/p/original/\(model.posterPath ?? "")",
                                                genre: genre,
                                                rating: model.voteAverage ?? 0,
                                                youtubeLink: youtubeKey)
            completion(movieDetailDTO)
        }
    }
}
