//
//  CurrentMoviesViewController.swift
//  MovieList
//
//  Created by Denis Lagunowski on 24/05/2023.
//

import UIKit

protocol CurrentMoviesViewProtocol: AnyObject {
    func populateMovies(movies: [Movie]?, page: Int, errorMsg: String?)
}

final class CurrentMoviesViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableVieew: UITableView!
    
    var currentMovies = [Movie]();
    private var moviesResult: [Movie]?
    private let pageConstant = 1
    private var currentPage = 1
    let searchConrtoller = UISearchController();
        
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // set nav bar
        navigationItem.title = "New movies"
        navigationItem.searchController = searchConrtoller
        getMovies(id: 1, page: currentPage)
    }
    
    
    func getMovies(id: Int, page: Int) {
        fetchMovies(id: "\(id)", page: page)
    }
    
    func didSelectMovies(indexPath: IndexPath, movies: [Movie]) {
        let movie = movies[indexPath.item]
       showMovieDetails(movie: movie)
    }
    
    func showMovieDetails(movie: Movie) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"MovieDetailsViewController") as? MovieDetailsViewController
        vc!.movie = movie
        self.navigationController?.pushViewController(vc!, animated: true)
    }
        
    func showMovies(movies: [Movie]?, errorMsg: String?) {
        moviesResult?.removeAll()
        moviesResult = movies
        
        self.currentMovies = movies!
        self.collectionView?.reloadData()
    }
    
    func fetchMovies(id: String, page: Int) {
        let shared = MovieServices()

        shared.fetchMovies(completion: )(

        ) {[weak self] result in
            switch result {
            case .success(let response):
                self?.showMovies(
                    movies: response.results,
                    errorMsg: nil
                )
            case .failure(let error):
                self?.showMovies(
                    movies: nil,
                    errorMsg: error.localizedDescription
                )
            }
        }
    }
}



extension CurrentMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.currentMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCurrentCell", for: indexPath) as! MovieCell
        cell.movie = currentMovies[indexPath.item]
        
        return cell
    }
}

extension CurrentMoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectMovies(indexPath: indexPath, movies: self.currentMovies)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         CGSize(width: 100.0, height: 100)
    }
}
