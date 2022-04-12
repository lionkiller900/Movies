//
//  MockNetworkManager.swift
//  MoviesTests
//
//  Created by Admin on 12/04/2022.
//

import Foundation
@testable import Movies
import Combine

class MockNetworkManager: Networkable {
    func doApiCall(apiRequest: ApiRequestType) -> Future<Data, ServiceError> {
        return Future { promise in
            
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:apiRequest.params["query"], withExtension:"json"),
                  let data = try? Data(contentsOf: url)

            else {
                promise(.failure(ServiceError.dataNotFound))
          
                return
            }
            promise(.success(data))
        }
    }
}
