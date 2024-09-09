//
//  MovieDetails.swift
//  MovieVault
//
//  Created by Thomas on 09/09/2024.
//

import UIKit
import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String
}


class MovieDetails: UIViewController {
    
    var movieId:Int=0
    @IBOutlet weak var movieTitle: UILabel!
    
    func getData() async{
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "fr-FR"),
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4NDhlNmY3YmQ3NmUyNGEwYzMzYzkxMmQzY2VkNGE3ZiIsIm5iZiI6MTcyNTg4NDExNC44ODgzNDcsInN1YiI6IjY2ZGVlM2Y5MTFjYWIyMTc1NjZkNGYxZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AP3WeS0k3HQp-6Y6ELRTc6115j_h-QklVwE1vVIGclc"
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            let movie = try JSONDecoder().decode(MovieDetail.self, from: data)
            
            movieTitle.text = movie.title
        } catch let error as NSError {
            print("Request failed with error: \(error.localizedDescription)")
        }

       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await getData()
        }
        
        
        
        
    }
    
    
}
