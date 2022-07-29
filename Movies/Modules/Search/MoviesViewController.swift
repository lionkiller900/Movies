//
//  MoviesViewController.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//


import UIKit
import Combine

// This view is a cloned View

class MoviesViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchTextField: UITextField!
    
    let pendingOperations = PendingOperations()

    var movies:[Movie] = []
    
    private var bindings = Set<AnyCancellable>()
    
    let viewModel:MoviesViewModelType = MoviesViewModel(repository: MovieRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel.showFavouriteMovies()
        setupBindings()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupBindings() {
        bindSearchTextFieldToViewModel()
        bindViewModelState()
    }

    private func bindViewModelState() {
      let cancellable =  viewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    
    private func bindSearchTextFieldToViewModel() {
        searchTextField?.textPublisher
             .debounce(for: 0.5, scheduler: RunLoop.main)
             .removeDuplicates()
             .sink { [weak self] in
                    self?.viewModel.searchMovies(keyword: $0)
             }
             .store(in: &bindings)
    }
    
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            tableView.isHidden = true
        case .searchInProgress:
            tableView.isHidden = true
            activityIndicator.startAnimating()
        case .searchCompleted(let movies):
            tableView.isHidden = false
            activityIndicator?.stopAnimating()
            self.movies = movies
            tableView.reloadData()
        case .error(let error):
            activityIndicator.stopAnimating()
            tableView.reloadData()
            self.showAlert(message:error)
        }
    }
    
    func startDownload(for movie: Movie, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      let downloader = ImageDownloader(movie)
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
            
          self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }
}

extension MoviesViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let movie = self.movies[indexPath.row]
        cell.setData(movie:movie, index: indexPath.row)
        
        switch (movie.state) {
       
        case .failed:
            print("Failed to load")
        case .new :
              startDownload(for: movie, at: indexPath)
          
        case .downloaded :
            cell.posterImageView.image = movie.image
        }
        
        return cell
    }
}


extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.movies[indexPath.row]
        let detailsViewModel = MovieDetailsViewModel(movie: movie)
        if  let detailsVC = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier:"MovieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.viewModel = detailsViewModel
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}


extension MoviesViewController: MovieCellDelegate {
    func favAction(isSelected: Bool, index: Int) {
        
        let movie  = self.movies[index]
        movie.isFav = isSelected
        viewModel.markFavourite(movie: movie)
    }
}
