//
//  AppDelegate.swift
//  userLocation
//
//  Created by Lisa Steele on 1/9/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import Onboard


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ref: DatabaseReference?
    let gcmMessageIDKey = "gcm.message_id"
    var userInfo: String = ""
    var userToken = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
            
            Messaging.messaging().delegate = self //as? MessagingDelegate
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: .firInstanceIDTokenRefresh, object: nil)
        
        UINavigationBar.appearance().tintColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)]
        
        let defaults = UserDefaults.standard
        let userHasOnboarded = defaults.bool(forKey: "userHasOnboarded")
        //self.window?.rootViewController = self.generateStandardOnboardingVC()
        
        if userHasOnboarded {
            self.setupNormalRootViewController()
        } else {
            self.window?.rootViewController = self.generateStandardOnboardingVC()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //if receiving message while app is in background, this callback will not be fired until user taps on notification launchign app.
        //Handle data of notification.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print ("Mssage ID: \(messageID)")
        }
        
        print (userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //if receiving message while app is in background, this callback will not be fired until user taps on notification launchign app.
        //Handle data of notification.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print ("Message ID: \(messageID)")
        }
        
        print (userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        //to perform action when app is opened upon notification click, set click_action in notification payload.
    }
    
    
    func tokenRefreshNotification(_ notification: Notification) {
        if InstanceID.instanceID().token() != nil {
            printFCMToken()
        } else {
            print ("We dont have an FCM token yet.")
        }
        
        connectToFCM()
    }
   
    
    func printFCMToken() {
        if let token = InstanceID.instanceID().token() {
            print ("Your FCM token is \(token)")
        } else {
            print ("You don't get have an FCM token.")
        }
    }
    
    func connectToFCM() {
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        
        Messaging.messaging().shouldEstablishDirectChannel = false
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print ("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print ("Connected to FCM")
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print ("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var readableToken: String = ""
        for i in 0..<deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print ("method run")
        print ("APNs token retrieved: \(readableToken)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
        //userInfo dictionary will contain the payload.
        //displayAlertMessage(messageToDisplay: "Someone has shared a journey with you.")
        //may need to write a test to see if app .isActive (or something similar)
        
    }
  
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
        print ("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "", message: messageToDisplay, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction!) in
        }
        alertController.addAction(dismissAction)
        
        let viewAction = UIAlertAction(title: "View", style: .default) { (action: UIAlertAction!) in
            //segue to the Live Journeys VC
        }
        alertController.addAction(viewAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func generateStandardOnboardingVC () -> OnboardingViewController {
        var onboardingVC = OnboardingViewController()
        
        let firstPage = OnboardingContentViewController.content(withTitle: "See You Soon!", body: nil, image: UIImage(named: ""), buttonText: nil, action: nil)
        
        let secondPage = OnboardingContentViewController.content(withTitle: "Share a journey with someone.", body: "Let them know you're on your way.", image: UIImage(named: "Share"), buttonText: nil, action: nil)
        
        let thirdPage = OnboardingContentViewController.content(withTitle: "Your journey is plotted on a map.", body: "Friends and family can see the route you're taking.", image: UIImage(named: "PlotOnMap"), buttonText: nil, action: nil)
        
        let fourthPage = OnboardingContentViewController.content(withTitle: "The map will also show your ETA.", body: "That way they know when to expect you.", image: UIImage(named: "ETA"), buttonText: "Get started", action: self.handleOnboardingCompletion)
        
        onboardingVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: ""), contents: [firstPage, secondPage, thirdPage, fourthPage])
        onboardingVC.view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0).lighten(byPercentage: 70)
        onboardingVC.shouldFadeTransitions = true
        onboardingVC.shouldMaskBackground = false
        onboardingVC.shouldBlurBackground = false
        onboardingVC.fadePageControlOnLastPage = true
        onboardingVC.pageControl.pageIndicatorTintColor = UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.0)
        onboardingVC.pageControl.currentPageIndicatorTintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        onboardingVC.allowSkipping = false
        onboardingVC.swipingEnabled = true
        fourthPage.actionButton.backgroundColor = UIColor(red:0.20, green:0.38, blue:0.45, alpha:1.0)
        
        
        
        return onboardingVC
    }
    
    func handleOnboardingCompletion() {
        self.setupNormalRootViewController()
    }
    
    func setupNormalRootViewController() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.window?.rootViewController = viewController
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "userHasOnboarded")
    }
    func skip() {
        self.setupNormalRootViewController()
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        
        completionHandler([.alert, .sound])
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]

extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        userInfo = fcmToken
        print ("Firebase registration token: \(fcmToken)")
        
    }

}


