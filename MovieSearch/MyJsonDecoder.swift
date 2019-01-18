//
//  MyJsonDecoder.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import Foundation

class MyJsonDecoder {
    private let apiKey = "740136f600cd94b0f24172b141ba08cf"
    var url: URL?
    
    enum Mode {
        case popular
        case search
        case detail
        case recommendation
    }
    
    init?(mode: Mode, searchText: String? = nil, page: Int? = nil, id: Int? = nil) {
        var rawUrl: String
        if (mode == .popular) {
            rawUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page!)"
        } else if (mode == .search) {
            rawUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchText!)&page=\(page!)"
        } else if (mode == .detail) {
            rawUrl = "https://api.themoviedb.org/3/movie/\(id!)?api_key=\(apiKey)"
        } else if (mode == .recommendation) {
            rawUrl = "https://api.themoviedb.org/3/movie/\(id!)/recommendations?api_key=\(apiKey)"
        } else {
            return nil
        }
        let urlStr = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        url = URL(string: urlStr!)
    }
    
    func requestData() -> APIResults? {
        print("Request data from \(String(describing: url))")
        let data = try? Data(contentsOf: url!)
        guard data != nil else {
            print("Error when getting data")
            return nil
        }
        let result = try! JSONDecoder().decode(APIResults.self, from: data!)
        return result
    }
    
    func requestDetail() -> Movie? {
        print("Request data from \(String(describing: url))")
        let data = try? Data(contentsOf: url!)
        guard data != nil else {
            print("Error when getting data")
            return nil
        }
        let result = try! JSONDecoder().decode(Movie.self, from: data!)
        return result
    }
}
