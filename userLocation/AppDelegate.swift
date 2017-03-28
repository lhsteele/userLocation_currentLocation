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

    //var listOfFavorites: [SavedFavorites] = []
    var listOfFavorites: [String] = []
    var window: UIWindow?
    var databaseHandle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var username = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        let databaseRef = FIRDatabase.database().reference().child("Users").child("Username").child("Favorites")
        username = "Lisa"
        
        let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                if let dbLocation = item as? FIRDataSnapshot {
                    
                    for item2 in dbLocation.children {
                        
                        
                        /*
                         I think initalizing these objects here is messing with the same initalized objects in the userFavorites class. However, because the scope of the favoriteLocation, lat Coord, and longCoord are so small, they are otherwise unaccessible.
                         var latCoordName: String?
                         var latCoord: Double?
                         var longCoordName: String?
                         var longCoord: Double?
                         var favoriteLocation: String?
                         var latString: String?
                         var longString: String?
                         var savedLatCoord: Double?
                         */
                        /*
                         var updatedLocation = ""
                         var updatedLat = Double()
                         var updatedLong = Double()
                         */
                        
                        
                        if let pair = item2 as? FIRDataSnapshot {
                            
                            
                            if let location = pair.value as? String {
                                
                                if let favoriteLocation = location as? String {
                                    self.listOfFavorites.append(favoriteLocation)
                                    //let updatedLocation = SavedFavorites(location: favoriteLocation)
                                    print (favoriteLocation)
                                }
                            } else if let value = pair.value as? Double? {
                                
                                let valueName = pair.key as? String
                                
                                if valueName == "Latitude" {
                                    if let latCoordName = valueName {
                                        if let latCoord = value {
                                            let latString = ("\(latCoordName) \(latCoord)")
                                            let savedLatCoord = latCoord
                                            self.listOfFavorites.append(latString)
                                            //let updatedLat = SavedFavorites(latCoord: latCoord)
                                            print (latString)
                                        }
                                    }
                                } else {
                                    if let longCoordName = valueName {
                                        if let longCoord = value {
                                            let longString = ("\(longCoordName) \(longCoord)")
                                            self.listOfFavorites.append(longString)
                                            //let updatedLong = SavedFavorites(longCoord: longCoord)
                                            print (longString)
                                        }
                                    }
                                }
                                /*
                                 Tried to create a new object newFavorite, which is of type SavedFavorites, with variables declared outside the scope of the if statements, to avoid the error message 'SavedFavorites' has no member type ... But it is printing Optional(0.0), which means it's not saving properly, and it's still an optional. Can't use an if let on this statment as SavedFavorites is not an optional type.
                                 let newFavorite = SavedFavorites(latCoord: updatedLat, longCoord: updatedLong, location: updatedLocation)
                                 print(newFavorite.latCoord)
                                 self.listOfFavorites.append(newFavorite)
                                 */
                            }
                            //append objects to the array.
                        }
                        //use the array to populate table view.
                    }
                    print("===")
                    
                }
                
            }
            print("\"===\(self.listOfFavorites)")
            //print(self.listOfFavorites.latCoord)
            /*
             //I can't seem to access listOfFavorites.latCoord, etc, because it says value of type [SavedFavorites] has no member latCoord. Even though it does
             //By doing the below, I'm trying to see if these values are being saved into listOfFavorites. It prints Optional(nil), so it isn't.
             for favorite in self.listOfFavorites {
             print (favorite.latCoord as? Double?)
             print (favorite.longCoord as? Double?)
             print (favorite.location as? String?)
             }
             */
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

