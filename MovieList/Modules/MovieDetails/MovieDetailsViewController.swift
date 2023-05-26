//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Denis Lagunowski on 26/05/2023.
//

import UIKit

protocol MovieDetailsViewProtocol: AnyObject {
//    var movie: Movie? { get set }
}

final class MovieDetailsViewController: UIViewController {
    var movie: Movie?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var addToFavourite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeFavourite(_ sender: UIButton) {
        let  movieId = String(movie!.id)
        if (UserDefaults.standard.integer(forKey:movieId) > 0) {
            UserDefaults.standard.removeObject(forKey:movieId)
        }else {
            UserDefaults.standard.set(true, forKey:movieId)
        }
        sender.setImage(UIImage(systemName:UserDefaults.standard.integer(forKey:movieId) != 0 ? "star.fill" : "star"), for: .normal)

    }
}

extension MovieDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell", for: indexPath) as! MovieDetailsCell
        cell.movie = self.movie
        
        return cell
    }
}

extension MovieDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        700
    }
    
}

