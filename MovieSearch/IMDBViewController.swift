//
//  IMDBViewController.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import UIKit
import WebKit

class IMDBViewController: UIViewController {
    
    var imdb_id: String!
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let rawUrl = "https://www.imdb.com/title/\(imdb_id!)"
        print("Open webpage \(rawUrl)")
        let url = URL(string: rawUrl)
        let urlRequest = URLRequest(url: url!)
        webview.load(urlRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
