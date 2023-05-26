//
//  MovieDetailsCell.swift
//  MovieList
//
//  Created by Denis Lagunowski on 26/05/2023.
//

import UIKit

class MovieDetailsCell: UITableViewCell {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            if let data = try? Data(contentsOf: movie!.backdropURL) {
                backdropImageView.image = UIImage(data: data)
            }
            titleLabel.text = movie!.title
            overviewLabel.text = movie?.overview
            voteAverageLabel.text = String(format: "%.2f/10", movie!.voteAverage)
            releaseDateLabel.text = movie?.releaseDate
            let  movieId = String(movie!.id)
                favouriteButton.setImage(UIImage(systemName:UserDefaults.standard.integer(forKey:movieId) != 0 ? "star.fill" : "star"), for: .normal)

        }
    }
}
