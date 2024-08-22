//
//  AddMovieViewController.swift
//  MovieList
//
//  Created by Marco on 2024-07-25.
//

import UIKit

class AddMovieViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var ref: AddMovieProtocol?
    var movie: Movie?
    var databaseManager: DataBaseManager?
    var movieimage: UIImage = UIImage(named: "Not Found")!
    
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieRate: UITextField!
    @IBOutlet weak var movieReleaseDate: UITextField!
    @IBOutlet weak var movieGenre: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var warrningMessage: UILabel!
    
    override func viewDidLoad() {
        databaseManager = DataBaseManager.instance
        
        warrningMessage.isHidden = true
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            print("sorry")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        movieimage = info[.editedImage] as! UIImage
        imageView.image = (info[.editedImage] as! UIImage)
        self.dismiss(animated: true)
    }
    
    @IBAction func returnAndCallAdd(_ sender: Any) {
        if movieTitle.text == "" {
            warrningMessage.isHidden = false
            return
        } else {
            movie = Movie(
                title: movieTitle.text!,
                image: movieimage,
                rating: (movieRate.text! as NSString).floatValue,
                releaseYear: (movieReleaseDate.text! as NSString).integerValue,
                genre: [movieGenre.text == "" ? "Not Found" : movieGenre.text!]
            )
            
            ref?.addNewMovie(movie: movie!)
            databaseManager?.insert(movie: movie!)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
