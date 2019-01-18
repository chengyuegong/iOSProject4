//
//  FavoritesViewController.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let database = FavoritesDB()
    @IBOutlet weak var theTableView: UITableView!
    var theFavorites: [dbMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Favorites"
        setUpTableView()
    }
    
    func setUpTableView() {
        theTableView.dataSource = self
        theTableView.delegate = self
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "fCell")
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if (theTableView.isEditing) {
            sender.title = "Edit"
            theTableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            theTableView.setEditing(true, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        theFavorites = []
        theFavorites = database.loadDatabase()
        theTableView.reloadData()
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "fCell")
        cell.textLabel!.text = theFavorites[indexPath.row].title
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            database.deleteFromDatabase(id: theFavorites[indexPath.row].id)
            theFavorites.remove(at: indexPath.row)
            theTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favorites2detail", sender: theFavorites[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favorites2detail"{
            let dest = segue.destination as! DetailedViewController
            dest.id = (sender as! Int)
        }
    }
    
}

