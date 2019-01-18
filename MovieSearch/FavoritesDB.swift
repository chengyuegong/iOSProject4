//
//  FavoritesDB.swift
//  MovieSearch
//
//  Created by Chengyue Gong on 2019/1/18.
//  Copyright © 2019 Chengyue Gong. All rights reserved.
//

import Foundation

struct dbMovie {
    let id: Int!
    let title: String
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

class FavoritesDB {
    var database: FMDatabase
    
    init() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dbPath = docPath[0] + "/favorites.db"
        var fileExists = true
        if (!FileManager.default.fileExists(atPath: dbPath)) {
            fileExists = false
            print("Create a database at \(dbPath)")
        }
        database = FMDatabase(path: dbPath)
        if (!database.open()) {
            print("Failed to open database")
        }
        if (!fileExists) {
            let sqlStatement = "CREATE TABLE FAVORITES(ID INT PRIMARY KEY, TITLE STRING NOT NULL)"
            let rv = database.executeStatements(sqlStatement)
            if (!rv) {
                print("Failed to create a table")
            }
        }
    }
    
    func loadDatabase() -> [dbMovie] {
        var theFavorites: [dbMovie] = []
        do {
            let sqlStatement = "SELECT * FROM FAVORITES"
            print("SQL: \(sqlStatement)")
            let results = try database.executeQuery(sqlStatement, values: nil)
            while (results.next()) {
                let id = results.int(forColumn: "id")
                let title = results.string(forColumn: "title")
                print("Load movie: \(id), \(title!)")
                theFavorites.append(dbMovie(id:Int(id), title:title!))
            }
        } catch let error as NSError {
            print("Failed: \(error)")
        }
        return theFavorites
    }
    
    func addToDatabase(id: Int, movie: String) {
        let title = movie.replacingOccurrences(of: "'", with: "''")
        let sqlStatement = "INSERT INTO FAVORITES (ID,TITLE) VALUES (\(id),'\(title)')"
        print("SQL: \(sqlStatement)")
        let rv = database.executeStatements(sqlStatement)
        if (!rv) {
            print("Failed to add \(movie)(\(id)) to database")
        }
    }
    
    func deleteFromDatabase(id: Int) {
        let sqlStatement = "DELETE FROM FAVORITES WHERE ID = \(id)"
        print("SQL: \(sqlStatement)")
        let rv = database.executeStatements(sqlStatement)
        if (!rv) {
            print("Failed to delete the movie(\(id)) from database")
        }
    }
    
    func searchForMovie(id: Int) -> Bool {
        let sqlStatement = "SELECT * FROM FAVORITES WHERE ID = \(id)"
        print("SQL: \(sqlStatement)")
        do {
            let results = try database.executeQuery(sqlStatement, values: nil)
            if (results.next()) {
                let title = results.string(forColumn: "title")
                print("The movie(\(id)) \(title!) was in the favorites!")
                return true
            }
        } catch let error as NSError {
            print("Failed: \(error)")
        }
        return false
    }
}
