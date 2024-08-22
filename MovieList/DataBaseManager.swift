//
//  DataBaseManager.swift
//  MovieList
//
//  Created by Marco on 2024-07-29.
//

import Foundation
import SQLite3
import UIKit

class DataBaseManager{
    static var instance = DataBaseManager()
    var db: OpaquePointer?
    
    private init(){
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension("movies.sqlite")
            
            self.db = openDatabase(path: filePath)
            createTable()
            
            print("DataBaseManager instance is created")
        } catch {
            print(error)
        }
    }
    
    
    // Open database connection #######################################################
    func openDatabase(path:URL) -> OpaquePointer? {
      var db: OpaquePointer?
        if sqlite3_open(path.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(path.path)")
        return db
      } else {
        print("Unable to open database.")
       return nil
      }
    }
    
    
    // Create table if it doesn't exist #######################################################
    let createTableString = """
    CREATE TABLE IF NOT EXISTS movie(
    title char(255) not null,
    image BLOB,
    rating REAL,
    releaseYear INTEGER,
    genre char(255))
    """

    func createTable() {
      // 1
      var createTableStatement: OpaquePointer?
      // 2
      if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
          SQLITE_OK {
        // 3
        if sqlite3_step(createTableStatement) == SQLITE_DONE {
          print("Movie table created.")
        } else {
          print("Movie table is not created.")
        }
      } else {
        print("CREATE TABLE statement is not prepared.")
      }
      // 4
      sqlite3_finalize(createTableStatement)
    }
    
    
    // Insert movies #######################################################
    let insertStatementString = "INSERT INTO movie (title, image, rating, releaseYear, genre) VALUES (?, ?, ?, ?, ?);"

    func insert(movie: Movie) {
      var insertStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
          SQLITE_OK {
          
          guard let imageData =  movie.image.jpegData(compressionQuality: 1.0) else {
                  print("Failed to convert image to Data.")
                  return
              }
          
          sqlite3_bind_text(insertStatement, 1, NSString(string: movie.title).utf8String, -1, nil)
          
          imageData.withUnsafeBytes { bytes in
              let pointer = bytes.baseAddress
              sqlite3_bind_blob(insertStatement, 2, pointer, Int32(imageData.count), nil)
          }
          
          sqlite3_bind_double(insertStatement, 3, Double(movie.rating))
          sqlite3_bind_int(insertStatement, 4, Int32(movie.releaseYear))
          sqlite3_bind_text(insertStatement, 5, NSString(string: movie.genre.first ?? "Not Found").utf8String, -1, nil)
          
        if sqlite3_step(insertStatement) == SQLITE_DONE {
          print("\nSuccessfully inserted row.")
        } else {
          print("\nCould not insert row.")
        }
      } else {
        print("\nINSERT statement is not prepared.")
      }
      // 5
      sqlite3_finalize(insertStatement)
    }
    
    
    // Query table data #######################################################
    let queryStatementString = "SELECT * FROM movie;"

    func query() -> [Movie] {
      var movies: [Movie] = []
        
      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
          // 2
          while sqlite3_step(queryStatement) == SQLITE_ROW {
              
              let title = sqlite3_column_text(queryStatement, 0)
              
              var image: UIImage
              if let imageData = sqlite3_column_blob(queryStatement, 1) {
                  let data = Data(bytes: imageData, count: Int(sqlite3_column_bytes(queryStatement, 1)))
                  image = UIImage(data: data)!
              } else {
                  image = UIImage(named: "Not Found")!
              }
              
              let rating = sqlite3_column_double(queryStatement, 2)
              let releasYear = sqlite3_column_int(queryStatement, 3)
              var movieGenre: String
              if let genre = sqlite3_column_text(queryStatement, 4) {
                  movieGenre = String(cString: genre)
              } else {
                  movieGenre = "Not Found"
              }
              
              let movie: Movie = Movie(title: String(cString: title!), image: image, rating: Float(rating), releaseYear: Int(releasYear), genre: [movieGenre])
              
              movies.append(movie)
          }
      } else {
          // 6
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("\nQuery is not prepared \(errorMessage)")
      }
      // 7
      sqlite3_finalize(queryStatement)
      return movies
    }
    
    
    // delete a movie #######################################################
    let deleteStatementString = "DELETE FROM movie WHERE title = ?;"

    func delete(movie: Movie) {
      var deleteStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
          SQLITE_OK {
          sqlite3_bind_text(deleteStatement, 1, NSString(string: movie.title).utf8String, -1, nil)
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
          print("\nSuccessfully deleted row.")
        } else {
          print("\nCould not delete row.")
        }
      } else {
        print("\nDELETE statement could not be prepared")
      }
      
      sqlite3_finalize(deleteStatement)
    }
    
    // Close Connenction #######################################################
    func closeConnection() {
        sqlite3_close(db)
        print("Connection dismissed")
    }
}
