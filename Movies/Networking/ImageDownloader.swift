//
//  ImageDownloader.swift
//  Movies
//
//  Created by Admin on 12/04/2022.
//

import Foundation
import UIKit


class ImageDownloader: Operation {
    let movie: Movie
    
    init(_ movie: Movie) {
      self.movie = movie
    }
    
    override func main() {
      if isCancelled {
        return
      }
    
    guard let url = URL(string:"\(EndPoint.imagesBaseUrl)\(movie.poster)") else {return}
        
      guard let imageData = try? Data(contentsOf:url) else { return }
      
      //6
      if isCancelled {
        return
      }
      
      //7
      if !imageData.isEmpty {
          movie.image = UIImage(data:imageData)
          movie.state = .downloaded
      } else {
          movie.state = .failed
          movie.image = UIImage(named: "Failed")
      }
    }
  }


class PendingOperations {
    
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}


