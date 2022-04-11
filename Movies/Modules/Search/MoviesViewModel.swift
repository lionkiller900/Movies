//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import Foundation
import Combine

enum ViewState {
    case none
    case searchInProgress
    case searchCompleted([Movie])
    case error(String)
}

protocol MoviesViewModelType {
    var stateBinding: Published<ViewState>.Publisher { get }
    func searchMovies(keyword: String)
    func markFavourite(movie:Movie)
    func showFavouriteMovies()
}

final class MoviesViewModel: MoviesViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    
    private let repository:MovieRepositoryType
    private var cancellables:Set<AnyCancellable> = Set()
        
    @Published  var state: ViewState = .none

    init(repository:MovieRepositoryType) {
        self.repository = repository
    }

    func searchMovies(keyword: String) {
        if keyword.count > 0 {
            getMovies(searchedText: keyword)
        }else {
            showFavouriteMovies()
        }
    }
    
    private func getMovies(searchedText:String) {
        
        state = ViewState.searchInProgress
        let publisher =   self.repository.getMovies(searchedText: searchedText)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] movies in
            self?.state = ViewState.searchCompleted(movies)
        }

        self.cancellables.insert(cancalable)
    }
    
    func markFavourite(movie:Movie) {
        repository.saveOrRemoveFav(movie: movie)
    }
    
    func showFavouriteMovies() {
        
        let cancalable = repository.fetchFavMovies().sink { completion in
            
        } receiveValue: { [weak self] movies in
            self?.state = ViewState.searchCompleted(movies)
        }
        self.cancellables.insert(cancalable)
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}

