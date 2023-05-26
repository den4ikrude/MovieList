//
//  MovieServices.swift
//  MovieList
//
//  Created by Denis Lagunowski on 24/05/2023.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(completion: @escaping (Result<MovieResponse, Error>) -> ())
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, Error>) -> ())
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, Error>) -> ())
}

class MovieServices {
    private let apiKey = "ed0d76b60ab85d508b517896a0c68725"
    private let baseURL = "https://api.themoviedb.org/3"
    private let jsonDecoder = Utils.jsonDecoder
    
    func fetchMovies(completion: @escaping (Result<MovieResponse, Error>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/now_playing") else {
            completion(.failure(Error.self as! Error))
            return
        }
        
        self.loadUrlAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, Error>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            completion(.failure(Error.self as! Error))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: ["append_to_response": "videos, credits"],
            completion: completion
        )
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, Error>) -> ()) {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            completion(.failure(Error.self as! Error))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: [
                "language": "en-US",
                "include_adult": "false",
                "region": "US",
                "query": query
            ],
            completion: completion
        )
    }
    
    // Helper Method
    private func loadUrlAndDecode<D: Decodable>(
        url: URL,
        params: [String:Any]? = nil,
        completion: @escaping (Result<D, Error>) -> ()) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(Error.self as! Error))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map {URLQueryItem(name: $0.key, value: $0.value as? String)})
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(Error.self as! Error))
            return
        }
        
            URLSession.shared.dataTask(with: finalURL) { data, response,  _ in
                guard response is HTTPURLResponse else {
                    completion(.failure(Error.self as! Error))
                    return
                }
           

            do {
                let decodeResponse = try  self.jsonDecoder.decode(D.self, from: data!)
                self.executeCompletionHandlerInMainThread(with: .success(decodeResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(Error.self as! Error), completion: completion)
            }
            
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(
        with result: Result<D, Error>,
        completion: @escaping (Result<D, Error>) -> ()
    ) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
 
