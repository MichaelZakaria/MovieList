//
//  MovieDescriptionViewController.swift
//  MovieList
//
//  Created by Marco on 2024-07-24.
//

import Foundation
import UIKit

class MovieDescriptionViewController : UIViewController{
    var movie: Movie = Movie(title: "Sample", image: UIImage(named: "Not Found")!, rating: 0, releaseYear: 0, genre: [])
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        name.text = movie.title
        image.image = movie.image
        rate.text = movie.rating == 0.0 ? "Not found" : String(movie.rating)
        var type: String = ""
        for g in movie.genre{
            if (type.isEmpty){
                type.append(g)
            } else {
                type.append(", "+g)
            }
        }
        genre.text = type
        date.text = movie.releaseYear == 0 ? "Not Found" : String(movie.releaseYear)
    }
    
}
