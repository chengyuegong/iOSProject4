//
//  PopularViewController.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var theData: APIResults?
    var theMovies: [Movie] = []
    var theImages: [UIImage] = []
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Popular"
        setUpCollectionView()
        getPopular()
    }
    
    func setUpCollectionView() {
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        theCollectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: "portraitCell")
        theCollectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: "landscapeCell")
        // set up layout for collection view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = Functions.getItemSize(rect: UIScreen.main.bounds)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        theCollectionView.collectionViewLayout = layout
    }
    
    func getPopular() {
        activity.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            for page in [1,2] {
                self.fetchData(page: page)
            }
            self.theImages = Functions.cacheImages(movies: self.theMovies)
            DispatchQueue.main.async {
                self.theCollectionView.reloadData()
                self.activity.stopAnimating()
            }
        }
    }
    
    func fetchData(page: Int) {
        if let decoder = MyJsonDecoder(mode: .popular, page: page) {
            theData = decoder.requestData()
            guard theData != nil else {
                return
            }
            for item in theData!.results {
                theMovies.append(item)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        theCollectionView.reloadData()
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Functions.getItemSize(rect: collectionView.bounds)
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieViewCell
        if (UIDevice.current.orientation.isLandscape) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landscapeCell", for: indexPath) as! MovieViewCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "portraitCell", for: indexPath) as! MovieViewCell
        }
        cell.titleView.text = theMovies[indexPath.row].title
        cell.imageView.image = theImages[indexPath.row]
        return cell
    }
    
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // push on the detailed view
        performSegue(withIdentifier: "popular2detail", sender: theMovies[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popular2detail"{
            let dest = segue.destination as! DetailedViewController
            dest.id = (sender as! Int)
        }
    }

}
