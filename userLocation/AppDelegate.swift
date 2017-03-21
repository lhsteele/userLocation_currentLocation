//
//  AppDelegate.swift
//  userLocation
//
//  Created by Lisa Steele on 1/9/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseHandle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var username = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        /*
        //This works to print one LocationName of one Location child.
        //use ref property and safely unwrap here with if let
        let databaseRef = FIRDatabase.database().reference().child("Users").child("Username").child("Favorites").child("Location")
        
        username = "Lisa"
         
         //use ref property and safely unwrap here with if let
         let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
            if let item = snapshot.childSnapshot(forPath: "LocationName").value as? String {
                print ("===")
                print (item)
            }
         })
        */
 
        
        
        
        let databaseRef = FIRDatabase.database().reference().child("Users").child("Username")
        username = "Lisa"
         
        let databaseHandle = databaseRef.child("Favorites").observe(.value, with: { (snapshot) in
            if let result = snapshot.key as? [FIRDataSnapshot] {
                for child in result {
                    if let dbLocation = snapshot.childSnapshot(forPath: "LocationName") as? String {
                                
                    print ("===")
                    print (dbLocation)
                    }
                }
            
            }
            
        })
        
        
        return true
    }
  
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
}

