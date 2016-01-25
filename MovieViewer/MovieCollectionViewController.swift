//
//  MovieCollectionViewController.swift
//  MovieViewer
//
//  Created by Yousef Kazerooni on 1/24/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit


class MovieCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //Variable to store the API array of dictionaries
    var movies: [NSDictionary]?
    
    //Contains the result from the search bar
    var filteredData: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        collectionView.delegate = self
        
        
        apiNetworkRequest()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //***********1  Api network request Function
    func apiNetworkRequest () {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                        
                            
                            //Store the retrieved array of dictionaries into the instance variable movies created as a global, to be used later for setting the contents of the cells in another function.
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            
                            self.collectionView.dataSource = self
                            self.collectionView.reloadData()
                            
                    }
                }
                

        });
        task.resume()
        
    }
    
    
    //**********2 RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        // Make network request to fetch latest data
        apiNetworkRequest()
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    
    
    
    
    
    
    //***************Number of cells
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
                if let movies = movies {
                    return movies.count
                }
                else {
                    return 0
                }
    }
    
    
    //***************Populating the cells
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        
        //Parsing the array of dictionaries into its dictionaries (elements)
        let movie = movies![indexPath.row]
        
        //creating the image Url
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie ["poster_path"] as! String
        let imageUrl = NSURL (string: baseUrl + posterPath)
        
       
        
        cell.posterCollectionView.setImageWithURL(imageUrl!)
        
        
        
        return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
