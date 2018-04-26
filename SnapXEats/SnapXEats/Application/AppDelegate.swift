//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import FacebookCore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SnapXEatsNetworkManager.shared.startMonitoringNetwork()
        setupNavigationBarFont()
        presentInitialScreen()
        if #available(iOS 10.0, *) {
            registerForRichNotifications()
            UNUserNotificationCenter.current().delegate = self
        }
        
        // This is for FB
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if  url.scheme == SnapXEatsConstant.urlScheme  {
            return SnapXLinkingManager.shared.checkDeepLink(with: url)
        }
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        AppEventsLogger.activate(application)
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
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
        SDKSettings.limitedEventAndDataUsage = true
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Private Methods
    
    func presentInitialScreen() {
        RootRouter.shared.presentFirstScreen(inWindow: window!)
    }
    
    fileprivate func setupNavigationBarFont() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .black
        navigationBarAppearace.barTintColor = .white
        navigationBarAppearace.titleTextAttributes =  [NSAttributedStringKey.foregroundColor:UIColor.rgba(74.0, 74.0, 74.0, 1.0), NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 16.0)!]
    }
    
    fileprivate func setupBackButtonAppearance() {
        //UINavigationBar.appearance().backIndicatorImage = UIImage.backIcon
        //UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage.backIcon
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: .default)
    }
    
    @available(iOS 10.0, *)
    func registerForRichNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }        
    }
}


@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        RootRouter.shared.checkNotificationIdentifier(notification: notification, completionHandler: completionHandler)
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        RootRouter.shared.checkNotification(response: response, completionHandler: completionHandler)
    }
}
