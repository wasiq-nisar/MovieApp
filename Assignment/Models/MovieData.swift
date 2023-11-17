//
//  MovieData.swift
//  Assignment
//
//  Created by Muhammad Wasiq  on 15/11/2023.
//

import Foundation

struct MovieData : Decodable {
    let results: [Movie]
    
    struct Movie : Decodable {
        let title: String
        let poster_path: String
        let release_date: String
        let overview: String
        let vote_average: Double
        let vote_count: Int
    }
}
