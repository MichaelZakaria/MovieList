//
//  ViewController.swift
//  MovieList
//
//  Created by Marco on 2024-07-24.
//

import UIKit

class ViewController: UITableViewController, AddMovieProtocol {
    var movies: [Movie] = []
    var databaseManager: DataBaseManager?
    
    func addNewMovie(movie: Movie) {
        movies.append(movie)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        let cellNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "myCell")
        
        databaseManager = DataBaseManager.instance
        
//        let movie1 = Movie(title: "Home Alone", image: UIImage(named: "HA")!, rating: 9.2, releaseYear: 1999, genre: ["Comedy", "Family"])
//        let movie2 = Movie(title: "Scream", image: UIImage(named: "Scream")!, rating: 8.5, releaseYear: 2011, genre: ["Horror"])
//        let movie3 = Movie(title: "Bee", image: UIImage(named: "Bee")!, rating: 8, releaseYear: 2007, genre: ["Comedy", "Animation", "Family"])
//        let movie4 = Movie(title: "Fall", image: UIImage(named: "Fall")!, rating: 9.8, releaseYear: 2022, genre: ["Thriller"])
//        let movie5 = Movie(title: "Her", image: UIImage(named: "Her")!, rating: 7.5, releaseYear: 2013, genre: ["SCI-Fi","Drama"])
//        
//        databaseManager?.insert(movie: movie1)
//        databaseManager?.insert(movie: movie2)
//        databaseManager?.insert(movie: movie3)
//        databaseManager?.insert(movie: movie4)
//        databaseManager?.insert(movie: movie5)
        
        movies = databaseManager?.query() ?? []
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Movies"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MovieTableViewCell
        
        cell.movieName.text = movies[indexPath.row].title
        cell.movieImage.image = movies[indexPath.row].image
        cell.movieDate.text = String(movies[indexPath.row].releaseYear)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movieDescription: MyTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "StaticTableView") as! MyTableViewController
        
        movieDescription.movie = movies[indexPath.row]
        
        self.navigationController?.pushViewController(movieDescription, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in 
            self.databaseManager?.delete(movie: self.movies[indexPath.row])
            self.movies = self.databaseManager?.query() ?? []
            tableView.reloadData()
        }
        
        let swipeCongiguration = UISwipeActionsConfiguration(actions: [action])
        
        return swipeCongiguration
    }

    @IBAction func addNewMovie(_ sender: Any) {
        let addNewMovieView = self.storyboard?.instantiateViewController(withIdentifier: "addMovie") as! AddMovieViewController
        
        addNewMovieView.ref = self
        
        self.navigationController?.pushViewController(addNewMovieView, animated: true)
    }
    
}

