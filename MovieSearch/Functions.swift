//
//  Functions.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import Foundation
import UIKit

class Functions {
    static public func getItemSize(rect: CGRect) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        if (rect.width < rect.height) {
            width = (rect.width - 50) / 3
        } else {
            width = (rect.width - 70) / 5
        }
        height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    static func getImages(movie: Movie) -> UIImage {
        var theImage: UIImage
        if let posterPath = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            theImage = image!
        } else {
            theImage = UIImage(named: "NoPoster")!
        }
        return theImage
    }
    
    static func cacheImages(movies: [Movie]) -> [UIImage] {
        var theImages: [UIImage] = []
        for item in movies {
            if let posterPath = item.poster_path {
                let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                let data = try! Data(contentsOf: url!)
                let image = UIImage(data: data)
                theImages.append(image!)
            } else {
                theImages.append(UIImage(named: "NoPoster")!)
            }
        }
        return theImages
    }
}
