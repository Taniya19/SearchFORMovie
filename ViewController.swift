//
//  ViewController.swift
//  SearchBarAssignment
//
//  Created by Taniya on 22/07/19.
//  Copyright 2019 viktaan.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, webServiceDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    var detailViewController: MovieDetailsViewController? = nil
    var filteredMovies = [SetMovieDescription.MovieList]()
    var movies = [SetMovieDescription.MovieList]()

    let searchController = UISearchController(searchResultsController: nil)
    var movieListArray = NSArray()
    var movieListFilteredArrayFromIndex: [Int] = []
    var movieListFilteredArrayFromIndexCopy: [Int] = []

    var movieHiddenIndex: [Int] = []
    var movieID: [Int] = []
    var movieName: [String] = []
    var movieReleaseDate: [String] = []
    var movieposterPath: [String] = []
    var movieDetailPosterPath: [String] = []
    var moviebackDropPath: [String] = []
    var movieOverview: [String] = []
    var voteAverage : [Float] = []
    var movieLanguage : [String] = []
    
    var shouldShowSearchResults = false
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Browse Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Title"]
        searchController.searchBar.delegate = self
        
        // MARK: - Calling WebserviceClass and its getMoviemovieList APIMethod
        let wsm0 : WebserviceClass = WebserviceClass.sharedInstance
        wsm0.delegates = self
        wsm0.getMovieList()
    }
    
    func movieListResponse(dictionary:NSDictionary)
    {
        movieListArray = (dictionary.object(forKey: "results") as? NSArray)!
        if movieListArray.count > 0
        {
            for index in 0...movieListArray.count-1 {
                
                let aObject = movieListArray[index] as! [String : AnyObject]
            
                movieName.append(aObject["title"] as? String ?? "titleHere")
                movieID.append(aObject["id"] as? Int ?? 990)
        
                movieReleaseDate.append(aObject["release_date"] as? String ?? "releaseDateHere")
                movieLanguage.append(aObject["original_language"] as? String ?? "en")
                
                let Str = aObject["poster_path"]as? String ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"
                let url = NSString(format: "https://image.tmdb.org/t/p/w500%@",Str as? CVarArg ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")
                
                movieposterPath.append(url as String)
                
                //////
                
                let detailStr = aObject["backdrop_path"]as? String ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"
                let detailURL = NSString(format: "https://image.tmdb.org/t/p/w320_and_h180_bestv2%@",detailStr as? CVarArg ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")
                
                movieDetailPosterPath.append(detailURL as String)
                
                movieOverview.append(aObject["overview"] as? String ?? "Overview")
                moviebackDropPath.append(aObject["backdrop_path"] as? String ?? "backDropPath")
                voteAverage.append(aObject["vote_average"] as? Float ?? 0.0)
            }
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

            if(scope == "All"){
                return movieName.count
            }else{
                return movieListFilteredArrayFromIndex.count
            }
        }
        return movieName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if isFiltering() {
            
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            
            if(scope == "All"){
                
                let cell = tableView .dequeueReusableCell(withIdentifier: "movieTableCell", for: indexPath as IndexPath) as! MovieListTableViewCell
                cell.movieListImages.layer.cornerRadius = 10
                cell.movieListImages.layer.masksToBounds = true
                
                cell.movieGetTag.tag = indexPath.row
                
                cell.movieGetTag.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
                
                cell.movieTitleL?.text = movieName[indexPath.row]
                cell.movieOverviewL?.text = movieOverview[indexPath.row]
                let imgStr = movieposterPath[indexPath.item]
                
                let url = URL(string:imgStr)
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.sync() {
                        cell.movieListImages.image = UIImage(data: data)
                    }
                }
                
                task.resume()
                
                cell.movieRateL.text = "\(voteAverage [indexPath.row])"
                cell.movieReleaseDateL.text = "\(movieReleaseDate [indexPath.row])"
                
                return cell
            }else{
                
                for item in movieListFilteredArrayFromIndex {
                    let index: Int = item
                    let setMovieIDStr = movieID [index]
                    
                    let cell = tableView .dequeueReusableCell(withIdentifier: "movieTableCell", for: indexPath as IndexPath) as! MovieListTableViewCell
                    cell.movieListImages.layer.cornerRadius = 10
                    cell.movieListImages.layer.masksToBounds = true
                
                    cell.movieGetTag.tag = index
                    
                    cell.movieGetTag.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)

                    cell.movieTitleL?.text = movieName[index]
                    cell.movieOverviewL?.text = movieOverview[index]
                    let imgStr = movieposterPath[index]
                    
                    let url = URL(string:imgStr)
                    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.sync() {
                            cell.movieListImages.image = UIImage(data: data)
                        }
                    }
                
                    task.resume()
                
                    cell.movieRateL.text = "\(voteAverage [index])"
                    cell.movieReleaseDateL.text = "\(movieReleaseDate [index])"
                
                    movieListFilteredArrayFromIndex.remove(at: 0)
                    return cell
                }
            }
            
            return UITableViewCell()
        }else{
        
            let cell = tableView .dequeueReusableCell(withIdentifier: "movieTableCell", for: indexPath as IndexPath) as! MovieListTableViewCell
            cell.movieListImages.layer.cornerRadius = 10
            cell.movieListImages.layer.masksToBounds = true
            
            cell.movieGetTag.tag = indexPath.row
            
            cell.movieGetTag.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            
            cell.movieTitleL?.text = movieName[indexPath.row]
            cell.movieOverviewL?.text = movieOverview[indexPath.row]
            let imgStr = movieposterPath[indexPath.item]
            
            let url = URL(string:imgStr)
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.sync() {
                    cell.movieListImages.image = UIImage(data: data)
                }
            }
            
            task.resume()
            
            cell.movieRateL.text = "\(voteAverage [indexPath.row])"
            cell.movieReleaseDateL.text = "\(movieReleaseDate [indexPath.row])"
            
            return cell
        }
    }
    
    @IBAction func buttonClicked(_ sender: UIButton)
    {
        let buttonTapped = sender
        self.performSegue(withIdentifier: "showDetail", sender: buttonTapped.tag)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            if let indexPath = sender
                {
                var movie = SetMovieDescription.MovieList()
                
                let controller = segue.destination as! UINavigationController
                let movieDetailsVC = controller.topViewController as! MovieDetailsViewController

                let index: Int = indexPath as! Int//.row
                let getImageurlStr = movieDetailPosterPath[index]
                let setMovieIDStr = movieID [index]
                
                let url = URL(string: getImageurlStr)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    movie.ImgV = image
                    movie.name =  movieName[index]
                    movie.overView = movieOverview[index]
                    movie.rating = voteAverage[index]
                    movie.releaseDate = movieReleaseDate[index]
                    movie.language = movieLanguage[index]
                }else {
                    movie.ImgV = UIImage(named: "TMDB-green")
                    movie.name = "-"
                    movie.overView = "-"
                    movie.rating = 0.0
                    movie.releaseDate = "-"
                    movie.language = "-"
                }
                movieDetailsVC.setStructDataReference(structDataReference: movie); //passStruct
                
                movieDetailsVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                movieDetailsVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let filteredStrings = movieName.filter({(item: String) -> Bool in
            
            var stringMatch = item.range(of: (scope == "All" ? "" : searchText.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").joined(separator: "|")), options: .regularExpression, range: nil, locale: nil)
            
            stringMatch != nil ? true : false
            
            if searchBarIsEmpty() {
                return false
            }else{
                if((stringMatch) != nil){

                    var index = movieName.firstIndex(of: item)
                    
                    movieListFilteredArrayFromIndex.append(index ?? 0)
                    movieListFilteredArrayFromIndexCopy.append(index ?? 0)
                }
            }
            // Reload the tableview.
            tableView.reloadData()
            return stringMatch != nil ? true : false
        })
    }
    
    func searchBarIsEmpty() -> Bool {

        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension ViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        if isFiltering(){
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            movieListFilteredArrayFromIndex = []
            movieListFilteredArrayFromIndexCopy = []
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        }else{
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
            tableView.reloadData()
        }
    }
}

