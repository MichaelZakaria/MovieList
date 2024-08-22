//
//  MyTableTableViewCell.swift
//  MovieList
//
//  Created by Marco on 2024-08-04.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
