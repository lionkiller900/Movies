import XCTest
@testable import Movies

class MoviesViewModelTests: XCTestCase {
    var viewModel:MoviesViewModel!
    var respository:MovieRepository!
    var networkManager:MockNetworkManager!
    var movieCoreDataRepo:MockMovieCoreDataRepository!
    
    override func setUpWithError() throws {
        
        networkManager = MockNetworkManager()
        movieCoreDataRepo = MockMovieCoreDataRepository()
        
        respository = MovieRepository(networkManager: networkManager, movieCoreDataRepo: movieCoreDataRepo)
        viewModel = MoviesViewModel(repository: respository)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testSearchMovie_success() {
        
            
        viewModel.searchMovies(keyword: "")
     
        
        viewModel.$state.sink { state in
            
            switch state {
            case .none:
               print("none")

            case .searchInProgress:
               
                print("searchInProgress")

            case .searchCompleted(let movies):
                XCTAssertEqual(movies.count, 1)
            case .error(_):
                print("none")

            }
        }

    }
    
    func testSearchMovieForFavouriteMovies_success() {
        
        let movieApiRquest = ApiRequest(baseUrl: EndPoint.baseUrl, path: "movie_success", params: [:])
               
        viewModel.searchMovies(keyword: "movie_success")
        
        viewModel.$state.sink { state in
            
            switch state {
            case .none:
               print("none")

            case .searchInProgress:
               
                print("searchInProgress")

            case .searchCompleted(let movies):
                XCTAssertEqual(movies.count, 20)
            case .error(let error):
                print("none")

            }
        }
    }
    
    func testSearchMovieForFavouriteMovies_failure() {
    
               
        viewModel.searchMovies(keyword: "failure")
        
        viewModel.$state.sink { state in
            
            switch state {
            case .none:
               print("none")

            case .searchInProgress:
               
                print("searchInProgress")

            case .searchCompleted(let movies):
                print("searchCompleted")   case .error(let error):

                XCTAssertEqual(error.localizedLowercase, "network not availale"    )
            }
        }
    }
    
}
