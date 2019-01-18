//
//  DetailedViewController.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    let database = FavoritesDB()
    let enabledColor = UIColor(red: CGFloat(47.0/255), green: CGFloat(183.0/255), blue: CGFloat(236.0/255), alpha: 1.0) // #2fb7ec
    let disabledColor = UIColor.gray
    
    var id: Int!
    var theMovie: Movie?
    
    @IBOutlet weak var releaseAndVoteLabel: UILabel!
    @IBOutlet weak var runtimeAndGenresLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var posterView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        definesPresentationContext = true
        getDetails()
    }
    
    func getDetails() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchData()
            DispatchQueue.main.async {
                self.navigationItem.title = self.theMovie!.title
                // set up poster view
                self.posterView.image = Functions.getImages(movie: self.theMovie!)
                // set up infomation view
                // released year and rate
                self.setUpLabel1()
                // runtime and genres
                self.setUpLabel2()
                // set up button
                self.setUpAddButton()
                self.setButtonState()
            }
        }
    }
    
    func fetchData() {
        if let decoder = MyJsonDecoder(mode: .detail, id: id) {
            theMovie = decoder.requestDetail()
            if theMovie != nil {
                print("Got details of movie(\(id ?? -1))")
                return
            }
        }
        print("Cannot get details of movie(\(id ?? -1))")
    }
    
    func setUpLabel1() {
        let year: String
        if (theMovie!.release_date == "") {
            year = "Unknown"
        } else {
            year = String(theMovie!.release_date)
        }
        let rate = theMovie!.vote_average
        releaseAndVoteLabel.text = "\(year) | \(rate)/10"
    }
    
    func setUpLabel2() {
        let runtime = getRuntime()
        let genres = getGenres()
        if (runtime == nil && genres == nil) {
            runtimeAndGenresLabel.text = "-"
        } else if (runtime == nil) {
            runtimeAndGenresLabel.text = "\(genres!)"
        } else if (genres == nil){
            runtimeAndGenresLabel.text = "\(runtime!)"
        } else {
            runtimeAndGenresLabel.text = "\(runtime!) | \(genres!)"
        }
    }
    
    func getRuntime() -> String? {
        if let m = theMovie!.runtime {
            let hour = m / 60
            let min = m % 60
            if (hour == 0) {
                return "\(min)min"
            } else {
                return "\(hour)h \(min)min"
            }
        } else {
            return nil
        }
    }
    
    func getGenres() -> String? {
        var genres: String = ""
        if let gen = theMovie!.genres {
            if (gen.count == 0) {
                return nil
            }
            var range: ArraySlice<Genre>
            if (gen.count >= 3) {
                range = gen[0...2]
            } else {
                range = gen[0..<gen.count]
            }
            for (i,item) in range.enumerated() {
                if (i == 0) {
                    genres.append(item.name)
                } else {
                    genres.append(", \(item.name)")
                }
            }
            return genres
        } else {
            return nil
        }
    }
    
    func setUpAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.width / 15
        addButton.layer.masksToBounds = true
        addButton.setTitle("Add to Favorites", for: .normal)
        addButton.setTitle("Added", for: .disabled)
        let size = CGSize(width: 200, height: 40)
        addButton.setBackgroundImage(enabledColor.createImage(size), for: .normal)
        addButton.setBackgroundImage(disabledColor.createImage(size), for: .disabled)
    }
    
    func setButtonState() {
        if let m = theMovie {
            if (database.searchForMovie(id: m.id)) {
                addButton.isEnabled = false
                removeButton.isHidden = false
            } else {
                addButton.isEnabled = true
                removeButton.isHidden = true
            }
        }
        
    }
    
    @IBAction func showOverview(_ sender: UIButton) {
        performSegue(withIdentifier: "detail2overview", sender: theMovie!.overview)
    }
    
    @IBAction func showRecommendations(_ sender: UIButton) {
        performSegue(withIdentifier: "detail2recommendations", sender: id)
    }
    
    @IBAction func addToFavorites(_ sender: UIButton!) {
        database.addToDatabase(id: id, movie: theMovie!.title)
        addButton.isEnabled = false
        removeButton.isHidden = false
        print("\(theMovie!.title) is added to the favorites")
    }
    
    @IBAction func removeFromFavorites(_ sender: UIButton) {
        database.deleteFromDatabase(id: id)
        addButton.isEnabled = true
        removeButton.isHidden = true
        print("\(theMovie!.title) is deleted from the favorites")
    }
    
    @IBAction func seeMoreOnIMDB(_ sender: UIButton) {
        performSegue(withIdentifier: "detail2imdb", sender: theMovie!.imdb_id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail2overview") {
            let dest = segue.destination as! OverviewViewController
            dest.text = (sender as! String)
        } else if (segue.identifier == "detail2recommendations") {
            let dest = segue.destination as! RecommendationsViewController
            dest.id = (sender as! Int)
        } else if (segue.identifier == "detail2imdb") {
            let dest = segue.destination as! IMDBViewController
            dest.imdb_id = (sender as! String)
        }
    }
    
}

extension UIColor {
    func createImage(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (context) in
            self.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        return image
    }
}
