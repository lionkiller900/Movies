//
//  Movies.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import Foundation

class Movie {
    let movieId: Int
    let title: String
    let poster: String
    let reviews: Int
    let overView: String
    var isFav: Bool
    
    init(movieId:Int, title:String, poster:String, reviews:Int, overView: String, isFav:Bool = false) {
        self.movieId = movieId
        self.title = title
        self.poster = poster
        self.reviews  = reviews
        self.overView = overView
        self.isFav =  isFav
    }
}
