//
//  MovieManager.swift
//  Assignment
//
//  Created by Muhammad Wasiq  on 15/11/2023.
//

import Foundation
import UIKit
import Alamofire

protocol MovieManagerDelegate {
    func didGetAllMovies(moviesArray: [MovieModel])
}

struct MovieManager{
    let APIKey = "83d01f18538cb7a275147492f84c3698"
    let movieURL = "https://api.themoviedb.org/3/"
    
    var delegate: MovieManagerDelegate?
    //var getAllMoviesCompletion: (([MovieModel]) -> Void)?
    
    
//    func fetchMovies() {
//        let urlString = "\(movieURL)/discover/movie?api_key=\(APIKey)&sort_by=popularity.desc"
//        performRequest(with: urlString)
//    }
//    
//    func fetchSearchedMovie(movieName: String){
//        print(movieName)
//        let urlString = "\(movieURL)/search/movie?api_key=\(APIKey)&query=\(movieName)"
//        print(urlString)
//        performRequest(with: urlString)
//    }
    
//    func performRequest(with urlString: String){
//        if let url = URL(string: urlString){
//            let session = URLSession(configuration: .default)
//
//            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
//                if (error != nil){
//                    print("In task with ERROR: \(error!)")
//                    return
//                }
//
//                if let data = data{
//                    if let moviesArray = self.pasrseJSON(data){
//                        self.delegate?.didGetAllMovies(moviesArray: moviesArray)
//                    }
//                }
//            })
//            task.resume()
//        }
//    }
    
    func pasrseJSON(_ data: Data) -> [MovieModel]?{
        var moviesArray = [MovieModel]()
        var color: UIColor = UIColor.black
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(MovieData.self, from: data)
            for i in 0 ..< decodedData.results.count {
                let title = decodedData.results[i].title
                let imgPath = decodedData.results[i].poster_path
                let releaseDate = decodedData.results[i].release_date
                let overview = decodedData.results[i].overview
                let count = decodedData.results[i].vote_count
                let average = decodedData.results[i].vote_average
                
                let speratedReleaseDate = releaseDate.split(separator: "-")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let yearString = dateFormatter.string(from: Date())
                if (yearString == speratedReleaseDate[0]){
                    color = UIColor.red
                }
                else{
                    color = UIColor.black
                }
                
                let movie = MovieModel(title: title, releaseData: releaseDate, imgPath: imgPath, overview: overview, voteAverage: average, voteCount: count, cellColor: color)
                moviesArray.append(movie)
            }
            return moviesArray
        }
        catch {
            print("Error While Fetching the Data ERROR: \(error)")
            return nil
        }
    }
    
    func downloadImageWithAlamofire(posterPath: String?, completion: @escaping (UIImage?) -> Void) {
        guard let posterPath = posterPath else {
            completion(nil)
            return
        }

        let baseUrl = "https://image.tmdb.org/t/p/"
        let imageSize = "w500"
        let imageUrlString = baseUrl + imageSize + posterPath

        // Download the image using Alamofire
        AF.request(imageUrlString).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Alamofire request failed with error: \(error)")
                completion(nil)
            }
        }
    }
    
    func fetchMovies(completion: @escaping ([MovieModel]) -> Void) {
        let urlString = "\(movieURL)/discover/movie?api_key=\(APIKey)&sort_by=popularity.desc"
        performRequest(with: urlString, completion: completion)
    }
    
    func fetchSearchedMovie(movieName: String, completion: @escaping ([MovieModel]) -> Void){
        print(movieName)
        let urlString = "\(movieURL)/search/movie?api_key=\(APIKey)&query=\(movieName)"
        print(urlString)
        performRequest(with: urlString, completion: completion)
    }
    
    func performRequest(with urlString: String, completion: @escaping ([MovieModel]) -> Void) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                if (error != nil){
                    print("In task with ERROR: \(error!)")
                    completion([])
                    return
                }
                
                if let data = data{
                    if let moviesArray = self.pasrseJSON(data){
                        completion(moviesArray)
                    }
                }
                else{
                    completion([])
                }
            })
            task.resume()
        }
    }
    
}
