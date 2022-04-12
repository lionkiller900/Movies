//
//  MockMovieCoreDataRepository.swift
//  MoviesTests
//
//  Created by Admin on 12/04/2022.
//

import Foundation
@testable import Movies
import Combine
import CoreData

class MockMovieCoreDataRepository: MovieCoreDataRepositoryType {
    
    func saveFavMovie(movie: Movie) {
        
    }
    
    func fetchFavouriteMovies() -> Future<[Movie], ServiceError> {
        return Future { promise in
            promise(.success([Movie(movieId: 11, title:"Star Wars", poster: "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg", reviews: 8, overView: "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.", isFav: true)]))
        }
    }
    
    func fetchFavouriteMovie(movieId: Int, completion: @escaping (FavMovie?) -> ()) {
        
    }
    
    func removeFavMovie(movie: Movie) {
        
    }
    
}
