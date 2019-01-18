//
//  MovieViewCell.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    
    var imageView: UIImageView
    var titleView: UILabel
    
    override init(frame: CGRect) {
        let width = frame.width
        let height = frame.height
        let imageViewFrame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView = UIImageView(frame: imageViewFrame)
        let titleBGFrame = CGRect(x: 0, y: height-40, width: width, height: 40)
        let titleBGView = UIView(frame: titleBGFrame)
        let titleViewFrame = CGRect(x: 5, y: height-35, width: width-10, height: 30)
        titleView = UILabel(frame: titleViewFrame)
        super.init(frame: frame)
        
        // set up view for movie title
        titleBGView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        titleView.textColor = UIColor.white
        if (width < 90) {
            titleView.font = UIFont(name: "Helvetica-Bold", size: 10)
        } else if (width < 300) {
            titleView.font = UIFont(name: "Helvetica-Bold", size: 12)
        } else {
            titleView.font = UIFont(name: "Helvetica-Bold", size: 18)
        }
        titleView.numberOfLines = 2
        titleView.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleView.textAlignment = .center
        // border-radius
        layer.cornerRadius = bounds.size.width / 15
        layer.masksToBounds = true
        
        addSubview(imageView)
        addSubview(titleBGView)
        addSubview(titleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
