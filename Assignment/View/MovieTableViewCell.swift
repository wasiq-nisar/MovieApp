//
//  MovieTableViewCell.swift
//  Assignment
//
//  Created by Muhammad Wasiq  on 15/11/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(movieModel:MovieModel){
        self.movieLabel.text = movieModel.title
        self.movieRelease.textColor = movieModel.cellColor
        self.movieRelease.text = movieModel.releaseData
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
