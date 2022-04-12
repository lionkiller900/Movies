//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var reviewsLbl: UILabel!
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var viewModel:MovieDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        guard let viewModel = viewModel else {
            return
        }
 
        titleLbl.text = viewModel.movie.title
        descLbl.text = viewModel.movie.overView
        reviewsLbl.text = "\(viewModel.movie.reviews)"
       
        posterImageView.image = viewModel.movie.image
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
