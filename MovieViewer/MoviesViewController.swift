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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //Declare movies to later store the already parsed into a dictionary JSON, whose information would be otherwise stuck in its methond.
    var movies: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //after adding the dataSource and delegate protocols, we need to initialize our cells as the MoviesViewController to be the dataSource and delegate.
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //Api network request code

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
                            self.tableView.reloadData()
                            
                    }
                }
        });
        task.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //1st Method of dataSource Protocole = defines the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    
        
        
    }
    
    //2nd Method of dataSource Protocoles = allows refining the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //In the end, by casting it down to MovieCell, we make it a subclass and can access titleLabel and overviewLabel inside.
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        //On top we declared movies as an optional and now we must unwrap but if nil the program will crash
        let movie = movies![indexPath.row]
        
        //without force casting as a string, title would be "AnyObject" and can't be used as a Label text.
        let title = movie ["title"] as! String
        let overview = movie ["overview"] as! String
        
        //creating the image Url
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie ["poster_path"] as! String
        
        let imageUrl = NSURL (string: baseUrl + posterPath)
        
        
        cell.titelLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageUrl!)
        
    
        
        print ("row \(indexPath.row)")
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
