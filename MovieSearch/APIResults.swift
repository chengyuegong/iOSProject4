//
//  APIResults.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import Foundation

struct APIResults: Decodable {
    let page: Int
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
    // added
    let genres: [Genre]?
    let runtime: Int?
    let imdb_id: String?
}

struct Genre: Decodable {
    let id: Int!
    let name: String
}
