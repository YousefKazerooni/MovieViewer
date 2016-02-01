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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        //Setting the content size for the scroll view so that it know how much to scroll up or down
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie ["title"] as! String
        titleLabel.text = title
        
        
        let overview = movie ["overview"] as! String
         overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie ["poster_path"] as? String {
            
            let posterUrl = NSURL (string: baseUrl + posterPath)
            posterImageView.setImageWithURL(posterUrl!)
        }
        
        
        
        
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
