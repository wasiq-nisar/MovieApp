//
//  ViewController.swift
//  Assignment
//
//  Created by Muhammad Wasiq  on 15/11/2023.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviesManager = MovieManager()
    var movies = [MovieModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hello")
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        moviesManager.delegate = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        //moviesManager.fetchMovies()
        moviesManager.fetchMovies { moviesArray in
            self.movies = moviesArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - TableView DataSource
extension MoviesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MovieTableViewCell
        moviesManager.downloadImageWithAlamofire(posterPath: movies[indexPath.row].imgPath) { image in
            if let image = image {
                print("Downloaded image")
                self.movies[indexPath.row].image = image
                cell.movieImage.image = image
            }
            else {
                print("Image download failed.")
            }
        }
        cell.updateUI(movieModel: movies[indexPath.row])
        return cell
    }

}

//MARK: - SerachBar Delegate
extension MoviesViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let movieName = searchBar.text {
            if (searchBar.text != ""){
                //moviesManager.fetchSearchedMovie(movieName: movieName)
                moviesManager.fetchSearchedMovie(movieName: movieName) { moviesArray in
                    self.movies = moviesArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0){
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            //moviesManager.fetchMovies()
            moviesManager.fetchMovies { moviesArray in
                self.movies = moviesArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}


//MARK: - MovieManagerDelegate
extension MoviesViewController: MovieManagerDelegate {
    func didGetAllMovies(moviesArray: [MovieModel]) {
        self.movies = moviesArray
        for i in 0 ..< moviesArray.count {
            print("Title: \(movies[i].title)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableView Delegates
extension MoviesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMovieDescription", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MovieDescriptionViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.movieName = movies[indexPath.row].title
            destinationVC.count = String(movies[indexPath.row].voteCount)
            destinationVC.releaseDate = movies[indexPath.row].releaseData
            destinationVC.score = String(format: "%.2f", movies[indexPath.row].voteAverage)
            destinationVC.overview = movies[indexPath.row].overview
            destinationVC.image = movies[indexPath.row].image
        }
    }
}


