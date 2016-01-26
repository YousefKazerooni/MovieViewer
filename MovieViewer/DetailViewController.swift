//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Yousef Kazerooni on 1/25/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie ["title"] as! String
        let overview = movie ["overview"] as! String
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie ["poster_path"] as? String {
            
            let posterUrl = NSURL (string: baseUrl + posterPath)
            posterImageView.setImageWithURL(posterUrl!)
        }
        

        
    
        
        overviewLabel.text = overview
        titleLabel.text = title
        
        
        print (movie)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
