//
//  MovieRepository.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import Foundation
import Combine

protocol MovieRepositoryType {
    func getMovies(searchedText: String)->Future<[Movie], ServiceError>
    
    func saveOrRemoveFav(movie:Movie)
    func fetchFavMovies()-> Future<[Movie], ServiceError>
}

class MovieRepository: MovieRepositoryType {
   
    let networkManager: Networkable
    let movieCoreDataRepo: MovieCoreDataRepositoryType

    var cancellables:Set<AnyCancellable?> = Set()

    init(networkManager:Networkable = NetworkManager(),
         movieCoreDataRepo:MovieCoreDataRepositoryType = MovieCoreDataRepository()) {
        self.networkManager = networkManager
        self.movieCoreDataRepo = movieCoreDataRepo
    }
    

    func getMovies(searchedText: String) -> Future<[Movie], ServiceError> {
        return Future { [unowned self] promise in

            
            let apiRequest = ApiRequest(baseUrl: EndPoint.baseUrl, path: Path.movies, params: ["query":searchedText, "api_key": Constatns.apiKey])
            
            let favMoviePublisher = movieCoreDataRepo.fetchFavouriteMovies()
            
            let apiCallPublisher =   self.networkManager.doApiCall(apiRequest: apiRequest)
            
            let cancellable = Publishers.Zip(favMoviePublisher, apiCallPublisher).sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    return promise(.failure(error))
                }
                
            } receiveValue: { (favMovies, data) in
                guard let decodedResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                    return promise(.failure(ServiceError.parsingError))
                }
                
               let movies =  decodedResponse.results.map{ result in
                   Movie(movieId: result.id, title: result.title ?? "", poster: result.posterPath ?? "", reviews:Int(result.voteAverage ?? 0) , overView: result.overview ?? "",
                         isFav: favMovies.filter{ $0.movieId == result.id}.count > 0 ? true : false )
                }
                return promise(.success(movies))
            }
            
            self.cancellables.insert(cancellable)

        }
    }
       
    func saveOrRemoveFav(movie: Movie) {
        if movie.isFav {
            movieCoreDataRepo.saveFavMovie(movie: movie)
        }else {
            movieCoreDataRepo.removeFavMovie(movie: movie)
        }
    }
    
    func fetchFavMovies()-> Future<[Movie], ServiceError> {
        return movieCoreDataRepo.fetchFavouriteMovies()
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable?.cancel()
        }
    }
}
