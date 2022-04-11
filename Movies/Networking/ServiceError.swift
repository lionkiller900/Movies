//
//  ServiceError.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import Foundation

enum ServiceError: Error {
    case failedToCreateRequest
    case dataNotFound
    case parsingError
    case networkNotAvailable

}
