//
//  ViewController.swift
//  MovieVault
//
//  Created by Etudiant on 09/09/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var TableView: UITableView!


         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if segue.identifier=="intoDetails" {
                 let dest = segue.destination as! MovieDetails
                 dest.movieId = 365177       }
             else {

             }
         }

}

