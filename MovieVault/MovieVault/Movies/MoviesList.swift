//
//  ViewController.swift
//  MovieVault
//
//  Created by Thomas on 09/09/2024.
//

import UIKit

struct Movie: Codable {
    let id: Int
    let title: String
}

class MoviesList: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var TableView: UITableView!
    
    var movies: [Movie] = []
    var selectedMovieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        Task {
            await fetchMovies()
        }
    }
    
    func fetchMovies() async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4NDhlNmY3YmQ3NmUyNGEwYzMzYzkxMmQzY2VkNGE3ZiIsIm5iZiI6MTcyNTg4NDExNC44ODgzNDcsInN1YiI6IjY2ZGVlM2Y5MTFjYWIyMTc1NjZkNGYxZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AP3WeS0k3HQp-6Y6ELRTc6115j_h-QklVwE1vVIGclc"
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(MovieResponse.self, from: data)
            
            self.movies = response.results
            
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        } catch {
            print("Erreur lors de la récupération des films : \(error)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        selectedMovieId = selectedMovie.id
        print("Selected movie ID: \(selectedMovieId ?? -1)")
        performSegue(withIdentifier: "intoDetails", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "intoDetails" {
                if let dest = segue.destination as? MovieDetails {
                    if let movieId = selectedMovieId {
                        print("Preparing to pass movie ID: \(movieId)")
                        dest.movieId = movieId
                    }
                }
            }
    }
    
    struct MovieResponse: Codable {
        let results: [Movie]
    }
}
