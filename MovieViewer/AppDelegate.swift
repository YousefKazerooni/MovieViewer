//
//  AppDelegate.swift
//  MovieViewer
//
//  Created by Yousef Kazerooni on 1/18/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow (frame: UIScreen.mainScreen().bounds)
        
        //Create a variable that allows access to the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Using the storyboard, create a variable that allows access to the UINavigationController embedded in the storyboard
        //Through Navigation controller's stack, we have access to all the ViewControllers that use push segue
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        
        //Using the NavigationController, we can access the viewController; and then its property endpoint
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endpoint = "now_playing"
        //for customization always use the first viewcontroller that is hooked; in this case navigationController
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "nowPlaying")
        
        
        
        
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endpoint = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "topRated")
        
        
        
        
        //Creating a tab bar
        //note: using () at the end to initialize the UItabBarController
        let tabBarController = UITabBarController ()
        
        
        //Setting which tab has which viewController using an array
        //note: Must reference the Navigation controller, because that's where the story of the viewController starts
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        
        
        
        //set the initial viewController, call root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

