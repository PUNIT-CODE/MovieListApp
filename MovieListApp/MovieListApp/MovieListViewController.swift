//
//  ViewController.swift
//  MovieListApp
//
//  Created by Punit Thakali on 27/11/2023.
//

import UIKit

class MovieListViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {
    
   
    @IBOutlet var movieListTextField: UITextField!
    @IBOutlet var movieListTableView: UITableView!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        movieListTableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        movieListTableView.dataSource = self
        movieListTableView.delegate = self
        movieListTextField.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchMovies()              //on typing the textfield should return the function searchMovies()
        return true
    }
    func searchMovies(){
        
        movieListTextField.resignFirstResponder()    // makes sure that the textfield is the first to load once the app runs
    
        guard let text = movieListTextField.text, !text.isEmpty else{
            
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")        // allows users to type their own queries
        movies.removeAll()
        
        let apiKey = "93b6d334"
    
        URLSession.shared.dataTask(with: URL(string:"https://www.omdbapi.com/?apikey=\(apiKey)&s=\(query)&type=movie")!,
                                   completionHandler: { data, response, error in
            
            guard let data = data, error == nil else{
                
                return
            }
            
            
            var result: MovieResult?   //convert JSON to Swift key
            
            do {
                
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } 
            catch{
                
                print("Error")
            }

            
            guard let finalresult = result else{   //validate that the conversion succeds
                
                return
            }
            
            
            let newMovies = finalresult.Search          //updates the movies array
            self.movies.append(contentsOf: newMovies)
            
            DispatchQueue.main.async {
                
                self.movieListTableView.reloadData()
            }
            
        }).resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


