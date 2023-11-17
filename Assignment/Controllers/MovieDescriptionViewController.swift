//
//  MovieDescriptionViewController.swift
//  Assignment
//
//  Created by Muhammad Wasiq  on 16/11/2023.
//

import UIKit
import Alamofire

class MovieDescriptionViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var overview: String = ""
    var revenue: String = "Not Availible"
    var score: String = ""
    var count: String = ""
    var releaseDate: String = ""
    var movieName: String = ""
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieNameLabel.text = movieName
        revenueLabel.text = revenue
        countLabel.text = count
        scoreLabel.text = score
        releaseDateLabel.text = releaseDate
        overviewLabel.text = overview   
        imageView.image = image
    }
}
