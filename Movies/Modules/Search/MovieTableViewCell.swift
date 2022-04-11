//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Admin on 11/04/2022.
//

import UIKit
import Kingfisher

protocol MovieCellDelegate: AnyObject {
    func favAction(isSelected:Bool, index:Int)
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var overViewLbl: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var reviewsCountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    weak var delegate:MovieCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        titleLbl.text = ""
        overViewLbl.text = ""
        reviewsCountLbl.text = ""
        favButton.setImage(UIImage(named:"favourite_unselected"), for: .normal)

    }

    func setData(movie:Movie, index:Int) {
        titleLbl.text = movie.title
        reviewsCountLbl.text = "Ratings : \(movie.reviews)"
        favButton.tag = index
        let url = URL(string:"\(EndPoint.imagesBaseUrl)\(movie.poster)")
        posterImageView.kf.setImage(with: url)
        
        overViewLbl.text = movie.overView

        let imageName = movie.isFav ? "favourite_selected" : "favourite_unselected"
        favButton.setImage(UIImage(named: imageName), for: .normal)
        
        favButton.isSelected = movie.isFav

    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let imageName = sender.isSelected ? "favourite_selected" : "favourite_unselected"
        sender.setImage(UIImage(named: imageName), for: .normal)
        
        delegate?.favAction(isSelected:sender.isSelected, index: sender.tag)
    }


}
