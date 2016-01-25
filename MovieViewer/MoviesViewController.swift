//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Yousef Kazerooni on 1/18/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!
    
    //Declare movies to later store the already parsed into a dictionary JSON, whose information would be otherwise stuck in its methond.
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //after adding the dataSource and delegate protocols, we need to initialize our cells as the MoviesViewController to be the dataSource and delegate.
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
    
        
        //Api network request code

        apiNetworkRequest()
        
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //The initial state of the Network Error view
        toggleNetworkErrorView(false)
        
        
    }
        
        
        

  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    //***********1  Api network request code
    func apiNetworkRequest () {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        
        //line to make the hub appear
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            //line to make the hub disappear
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            //Store the retrieved array of dictionaries into the instance variable, to be used later for setting the contents of the cells.
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
                
                //Activates the intoggle of Network Error view if encounters nil
                if error != nil {
                    self.toggleNetworkErrorView(true)
                }
        });
        task.resume()

    }

    
    
    
    //*********** Network Error
    func toggleNetworkErrorView( visible: Bool) {
        if visible {
            networkErrorView.hidden = false
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseOut, animations: {
                self.view.bringSubviewToFront(self.networkErrorView)
                self.tableView.frame.origin.y += self.searchBar.frame.height
                }, completion: nil
            )
        } else {
            networkErrorView.hidden = true
        }
    }
    
    //**********2 RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        // Make network request to fetch latest data
        apiNetworkRequest()
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //********* Search Bar Fucntion
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movies: NSDictionary) -> Bool in
            return (movies["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            
        })
        
        tableView.reloadData()
    }
    
    //************ showing the cancel button upon editing in the search bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    //*********** activating the cancel button
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        //After removing cancel we must reload the view
        self.filteredData = self.movies
        self.tableView.reloadData()
        
    }
    
    //*********1st Method of dataSource Protocole = defines the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let movies = movies {
//            return movies.count
//        }
//        else {
//            return 0
//        }
        return filteredData?.count ?? 0
    
        
        
    }
    
    //***********2nd Method of dataSource Protocoles = allows refining the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //In the end, by casting it down to MovieCell, we make it a subclass and can access titleLabel and overviewLabel inside.
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        //On top we declared movies as an optional and now we must unwrap but if nil the program will crash
        //let movie = movies![indexPath.row]
        let movie = filteredData![indexPath.row]
        
        //without force casting as a string, title would be "AnyObject" and can't be used as a Label text.
        let title = movie ["title"] as! String
        let overview = movie ["overview"] as! String
        
        //creating the image Url
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie ["poster_path"] as! String
        //let imageUrl = NSURL (string: baseUrl + posterPath)
        
        
        //Making the images fading in upon loading the first time; i.e, not from the cache
        let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
        
        
        // Before we had the following code: cell.posterView.setImageWithURL(imageUrl!); now instead of just having (imageUrl) we have a whole statment
        cell.posterView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.9, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
                //????????????????????????????????
//                if imageResponse == nil {
//                    self.toggleNetworkErrorView(true)
//                }
            
        })
        
        
        
        cell.titelLabel.text = title
        cell.overviewLabel.text = overview
        
        
    
        
        print ("row \(indexPath.row)")
        return cell
        
    }
    
  
  

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Using sender to define what initiated the segue way
        let cell = sender as! UITableViewCell
        //Using the cell to determine its indexpath
        let indexPath = tableView.indexPathForCell(cell)
        //using the indexpath to extract the right movie out of the array
        let movie = movies! [indexPath!.row]
        
        
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
