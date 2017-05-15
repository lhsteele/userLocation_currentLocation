//
//  AppDelegate.swift
//  userLocation
//
//  Created by Lisa Steele on 1/9/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var databaseHandle: FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        //iOS10
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in }
            application.registerForRemoteNotifications()
        }
        
        //iOS9
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        //iOS8
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        //iOS7
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        //Called when APNs has assigned the device a unique token
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToekn deviceToken: Data) {
            //Convert token to string
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            
            //print it to console
            print ("APNs device token: \(deviceTokenString)")
            
            //Persist it in your backend in case it's new.
        }
        
        //Called when APNs failed to register the device for push notifications
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            //Print the error to console (you shoudl alert the user that registration failed)
            print("APNs registration failed: \(error)")
        }
        
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

