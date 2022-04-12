//
//  EndPoints.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import Foundation

//https://api.themoviedb.org/3/search/movie?api_key=3215a185b25eb297a66e63d137fb994f&language=en-US&query=Star

//https://image.tmdb.org/t/p/w300/lV5OpzAss1z06YNagOVap1I35mH.jpg?api_key=3215a185b25eb297a66e63d137fb994f

struct EndPoint {
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let imagesBaseUrl = "https://image.tmdb.org/t/p/w300/"
}

struct Path {
    static let movies = "search/movie/"
}
