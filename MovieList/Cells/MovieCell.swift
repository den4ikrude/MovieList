//
//  MovieCell.swift
//  MovieList
//
//  Created by Denis Lagunowski on 24/05/2023.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var movie: Movie? {
        didSet {
            if let data = try? Data(contentsOf: movie!.posterURL) {
                   // Create Image and Update Image View
                   imageView.image = UIImage(data: data)
               }
        }
    }

}
