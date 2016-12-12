//
//  AppDelegate.swift
//  Digout
//
//  Created by Daniel Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation



var storyboard = UIStoryboard(name: "Main", bundle: nil)

var initialViewControllerRoot: AnyObject = storyboard.instantiateInitialViewController()!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let defaults = UserDefaults.standard
    
    let api = APIInfo()
    
    let userHasOnboardedKey = "user_has_onboarded"
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set status bar to the light theme
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //***************************************
        // SET NEW ROOT VIEW CONTROLLER IF AUTH'D
        //***************************************
        
        if (defaults.object(forKey: "userIsAuthenticated") != nil){
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController")
        
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        
        
        //*********************************
        // MOBILE QUALITY ASSURANCE SETUP
        //*********************************
        
        /*
        //Set the SDK mode Market vs QA for Production and Pre-Production
        #if Debug
            MQALogger.settings().mode = MQAMode.QA
        #elseif Release
            MQALogger.settings().mode = MQAMode.market
        #endif
        
        // Set the application key
        MQALogger.startNewSession(withApplicationKey: "1g3ae27c9e4871fcb5374f9be546ad60081746c46ag0g2g39bf0cfd")
        
        // Set MQA uncaught exception handler for crashes
        NSSetUncaughtExceptionHandler(exceptionHandlerPointer)
        */
        
        return true
    }
    
    
    // MARK: Default App Delegate Methods

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

