//
//  RecommendationsViewController.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var id: Int!
    var theData: APIResults?
    var theMovies: [Movie] = []
    var theImages: [UIImage] = []
    var noRecommendationsLabel: UILabel? = nil
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        createNoRecommendationsLabel()
        getRecommendations()
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
        theCollectionView.layer.cornerRadius = theCollectionView.bounds.size.width / 20
        theCollectionView.layer.masksToBounds = true
    }
    
    func createNoRecommendationsLabel() {
        let noRecommendationsLabelFrame = CGRect(x: 20, y: 0, width: view.frame.width, height: 50)
        noRecommendationsLabel = UILabel(frame: noRecommendationsLabelFrame)
        noRecommendationsLabel!.textAlignment = .left
        noRecommendationsLabel!.font = UIFont(name: "Helvetica-LightOblique", size: 18)
        noRecommendationsLabel!.text = "No Recommendations Found."
    }
    
    func getRecommendations() {
        activity.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchData()
            self.theImages = Functions.cacheImages(movies: self.theMovies)
            DispatchQueue.main.async {
                self.theCollectionView.reloadData()
                self.activity.stopAnimating()
            }
        }
    }
    
    func fetchData() {
        if let decoder = MyJsonDecoder(mode: .recommendation, id: id) {
            theData = decoder.requestData()
            guard theData != nil else {
                return
            }
            for item in theData!.results {
                theMovies.append(item)
            }
            DispatchQueue.main.sync {
                if (theMovies.isEmpty) {
                    self.theCollectionView.addSubview(self.noRecommendationsLabel!)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
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
    
}
