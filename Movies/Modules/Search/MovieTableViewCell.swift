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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
