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
 
        
        //** queryEqualToValue?
        
        let databaseRef = FIRDatabase.database().reference().child("Users").child("Username").child("Favorites")
        username = "Lisa"
         
        let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
            //going through the children in the above snapshot
            for item in snapshot.children {
                //each child in snapshot doesn't have a data type, so we're casting it to a snapshot in order to access the .children property in line 54
                if let dbLocation = item as? FIRDataSnapshot {
                    
                    for item2 in dbLocation.children {
                        //create SavedFavorites objects as empty
                        //same as line 51 (.children by default contains AnyObjects, casting it to snapshot so we can access .value)
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            //need to cast AnyObjects to a specific data type
                            if let location = pair.value as? String {
                            //.key is printing out the "lat", "locationName", and "long"
                            //print(pair.key)
                            //here, populate location name for saved favorites object
                            print(location)
                            //casting to double to differentiate between the coordinates and the name
                            } else if let value = pair.value as? Double {
                                //to access which of the coordinates are lat and long
                                let valueName = pair.key as? String
                                // use "==" to compare the result to latitude, if so, populate latitude object
                                //else populate the longitude object
                                print(value)
                            }
                            
                        }
                        //append objects to the array.
                        //use the array to populate table view.
                    }
                    print("===")

                }
                    //if let dbLocation = .child("LocationName") as? String {
                                
                    //print ("===")
                    //print (dbLocation)
                    //}
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

