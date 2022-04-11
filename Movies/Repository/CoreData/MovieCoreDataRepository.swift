//
//  MovieCoreDataRepository.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import Foundation
import CoreData
import Combine

protocol MovieCoreDataRepositoryType {
    func saveFavMovie(movie:Movie)
    func fetchFavouriteMovies()-> Future<[Movie], ServiceError>
    func fetchFavouriteMovie(movieId:Int, completion:@escaping (FavMovie?) -> ())
    func removeFavMovie(movie:Movie)
}

class MovieCoreDataRepository: MovieCoreDataRepositoryType {
    func saveFavMovie(movie:Movie) {
        
        let moc = CoreDataManager.shared.persistentContainer.viewContext
        fetchFavouriteMovie(movieId: movie.movieId) { favMovie in
            
            guard favMovie == nil else { return }
            
            let favMovie = NSEntityDescription.insertNewObject(forEntityName:"FavMovie", into:moc) as? FavMovie
            favMovie?.movieId = Int64(movie.movieId)
            favMovie?.poster = movie.poster
            favMovie?.title = movie.title
            favMovie?.viewCount = Int64(movie.reviews)
            favMovie?.overView = movie.overView
            CoreDataManager.shared.saveContext()
        }
    }
    
    func fetchFavouriteMovies()-> Future<[Movie], ServiceError> {
        return Future { promise in
            let moc = CoreDataManager.shared.persistentContainer.viewContext

            let fr = FavMovie.fetchRequest()
            // Perform Fetch Request
            moc.perform {
                // Execute Fetch Request
                guard let  result = try? fr.execute() else {
                    return
                }
                let movies =  result.map{ Movie(movieId: Int($0.movieId) , title: $0.title ?? "", poster: $0.poster ?? "", reviews: Int($0.viewCount), overView: $0.overView ?? "", isFav: true)
                }
                promise(.success(movies))
            }
        }
    }
    
    
    func fetchFavouriteMovie(movieId:Int, completion:@escaping (FavMovie?) -> ()){
        let moc = CoreDataManager.shared.persistentContainer.viewContext

        let fr = FavMovie.fetchRequest()
        fr.predicate = NSPredicate(format: "movieId == %d", movieId)
        // Perform Fetch Request
        moc.perform {
            // Execute Fetch Request
            guard let  result = try? fr.execute() else {
                return
            }
            if result.count > 0 {
                completion(result.first)
            }else {
                completion(nil)
            }
        }
        
    }
    
    func removeFavMovie(movie:Movie) {
        
        let moc = CoreDataManager.shared.persistentContainer.viewContext

        fetchFavouriteMovie(movieId:movie.movieId) { favMovie in
            
            if let favMovie = favMovie {
                moc.delete(favMovie)
                CoreDataManager.shared.saveContext()
            }
            
        }
    }
}
